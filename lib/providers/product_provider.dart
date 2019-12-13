import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<product> _items = [
    product(
      id: 'p1',
      title: 'Red Shirt',
      content: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    product(
      id: 'p2',
      title: 'Trousers',
      content: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    product(
      id: 'p3',
      title: 'Yellow Scarf',
      content: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    product(
      id: 'p4',
      title: 'A Pan',
      content: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
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
    const url = 'https://flutterhttp-e85f8.firebaseio.com/products.json';

    final response=await http
        .post(url,
        body: json.encode({
          'title': prod.title,
          'description': prod.content,
          'imageUrl': prod.imageUrl,
          'price': prod.price,
          'isFavorite': prod.isFavorite,
        })
    );
    final newProduct = product(
        title: prod.title,
        id: json.decode(response.body)['name'],
        content: prod.content,
        imageUrl: prod.imageUrl,
        price: prod.price);
        _items.add(newProduct);
    notifyListeners();

  }


  product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void updateProduct(String id, product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
