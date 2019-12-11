import 'package:flutter/material.dart';
import 'screens/products_overview.dart';
import 'screens/product_details.dart';
import 'providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'providers/cart.dart';
import 'screens/cart_screen.dart';
import 'providers/orders.dart';
import 'screens/orders_screen.dart';
import 'screens/user_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductProvider(),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'lato',
          primarySwatch: Colors.indigo,
          accentColor: Colors.red,
        ),
        home: products_overview(),
        routes: {
          '/productDetails': (context) => ProductDetails(),
          '/cartScreen': (context) => CartScreen(),
          '/orders': (context) => OrderScreen(),
          '/userproduct': (context) => UserProduct(),
        },
      ),
    );
  }
}
