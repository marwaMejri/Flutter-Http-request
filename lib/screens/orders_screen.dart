import 'package:flutter/material.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataOrders=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(itemBuilder: (context,index) =>
      OrderItem(order:DataOrders.orders[index])
        ,
        itemCount: DataOrders.orders.length,
      ),
    );
  }
}
