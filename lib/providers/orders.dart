import 'package:flutter/cupertino.dart';
import 'cart.dart';


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

  void addOrders(List<CartItem> cartProducts, double total) {

    _orders.insert(
        0,
        OrderItem(
            dateTime: DateTime.now(),
            id: DateTime.now().toString(),
            products: cartProducts,
            amount: total));
    notifyListeners();
  }
}
