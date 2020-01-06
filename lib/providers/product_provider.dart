import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  List<product> _items = [];
  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this._items, this.userId);
  var _showFavoritesOnly = false;
  List<product> get items {
    if (_showFavoritesOnly) {
      return _items.where((Items) => Items.isFavorite).toList();
    }
    return [..._items];
  }

  void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  Future<void> addProduct(product prod) async {
    final url =
        'https://flutterhttp-e85f8.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': prod.title,
            'description': prod.content,
            'imageUrl': prod.imageUrl,
            'price': prod.price,
            'creatorId': userId,
          }));
      final newProduct = product(
          title: prod.title,
          id: json.decode(response.body)['name'],
          content: prod.content,
          imageUrl: prod.imageUrl,
          price: prod.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetProduct([bool filterByUser=false ]) async {
    final filterByOwner= filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://flutterhttp-e85f8.firebaseio.com/products.json?auth=$authToken&$filterByOwner';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      final url2 =
          'https://flutterhttp-e85f8.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url2);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(product(
            id: prodId,
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            content: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutterhttp-e85f8.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.content,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'id': newProduct.id,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void deleteProduct(String id) async {
    final url =
        'https://flutterhttp-e85f8.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
