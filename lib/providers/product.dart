import 'package:flutter/foundation.dart';

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

  void toggleFavorites()
  {
    isFavorite=!isFavorite;
    notifyListeners();
  }
}

