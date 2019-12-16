import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class product with ChangeNotifier{
  final String id;
  final String title;
  final String content;
  final double price;
  final String imageUrl;
  bool isFavorite=true;

  product(
      {this.isFavorite=false,
      @required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.content,
      @required this.price});
  void _setFavValue(bool newValue){
    isFavorite=newValue;
    notifyListeners();
  }
  Future<void> toggleFavorites () async
  {
    final oldStatus=isFavorite;
    isFavorite=!isFavorite;
    notifyListeners();
    final url='https://flutterhttp-e85f8.firebaseio.com/products/$id.json';
    try {
      final response=await http.patch(url, body:
      json.encode({
        'isFavorite': isFavorite,
      })
      );
      if(response.statusCode>=400){
        _setFavValue(oldStatus);
      }
    }catch(error){

     _setFavValue(oldStatus);
    }

  }
}

