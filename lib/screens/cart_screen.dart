import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$${cartData.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Colors.yellow[300],
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context,listen: false).addOrders(
                          cartData.items.values.toList(), cartData.totalAmount);
                      cartData.clear();
                    },
                    child: Text('ORDER NOW'),
                    textColor: Colors.pinkAccent[100],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartData.itemCount,
                itemBuilder: (context, index) => ci.CartItem(
                    productId: cartData.items.keys.toList()[index],
                    id: cartData.items.values.toList()[index].id,
                    price: cartData.items.values.toList()[index].price,
                    quantity: cartData.items.values.toList()[index].quantity,
                    title: cartData.items.values.toList()[index].title)),
          )
        ],
      ),
    );
  }
}
