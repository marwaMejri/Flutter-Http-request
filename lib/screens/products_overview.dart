import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';

class products_overview extends StatefulWidget {
  @override
  _products_overviewState createState() => _products_overviewState();
}

class _products_overviewState extends State<products_overview> {
  var _isInit=true;
  var _isLoading=false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int selectedValue) {
              if (selectedValue == 0) {
                productItem.showFavoritesOnly();
              } else {
                productItem.showAll();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.red[700],
              size: 40,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only favorites'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('show all '),
                value: 1,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(

                child: ch,
                value: cartData.itemCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cartScreen');

              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Center(child: _isLoading ? CircularProgressIndicator(): ProductsGrid()),
    );
  }
}
