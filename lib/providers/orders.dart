import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem(
      {@required this.dateTime,
      @required this.id,
      @required this.products,
      @required this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    const url = 'https://flutterhttp-e85f8.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts.map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              }).toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            dateTime: timestamp,
            id: json.decode(response.body)['name'],
            products: cartProducts,
            amount: total));
    notifyListeners();
  }
  Future<void> fetchAndSetOrders() async{
    const url = 'https://flutterhttp-e85f8.firebaseio.com/orders.json';
    final response=await http.get(url);
    print(json.decode(response.body));
  }
}
