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
                   OrderButton(cartData: cartData)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator():Text('ORDER NOW'),
      textColor: Colors.pinkAccent[100],
      onPressed: (widget.cartData.totalAmount<=0 || _isLoading) ? null : () async{
        setState(() {
          _isLoading=true;
        });
       await Provider.of<Orders>(context,listen: false).addOrders(
            widget.cartData.items.values.toList(),
            widget.cartData.totalAmount);
       setState(() {
         _isLoading=false;
       });
        widget.cartData.clear();
      },
    );
  }
}
