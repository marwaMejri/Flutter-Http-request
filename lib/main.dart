import 'package:app3/providers/auth.dart';
import 'package:app3/screens/authentification_screen.dart';
import 'package:app3/screens/splash_screen.dart';
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
import 'screens/edit_product.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          // ignore: deprecated_member_use
          builder: (ctx, auth, previousProducts) => ProductProvider(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          // ignore: deprecated_member_use
          builder: (ctx, auth, previousOrder) => Orders(auth.token,
              previousOrder == null ? [] : previousOrder.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          theme: ThemeData(
            fontFamily: 'lato',
            primarySwatch: Colors.purple,
            accentColor: Colors.red,
          ),
          home: auth.isAuth
              ? products_overview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            '/productDetails': (context) => ProductDetails(),
            '/cartScreen': (context) => CartScreen(),
            '/orders': (context) => OrderScreen(),
            '/userproduct': (context) => UserProduct(),
            '/editProduct': (context) => EditProduct(),
            '/authScreen': (context) => AuthScreen()
          },
        ),
      ),
    );
  }
}
