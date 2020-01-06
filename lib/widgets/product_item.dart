
import 'package:app3/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   final prod= Provider.of<product>(context,listen: false);
   final cart=Provider.of<Cart>(context,listen: false);
   final authData=Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: (){
             Navigator.of(context).pushNamed('/productDetails',arguments:
             prod.id
             );
            },
            child: FadeInImage(
              fit: BoxFit.cover,
              image: NetworkImage(prod.imageUrl),
              placeholder: AssetImage('Assets/images/loading.gif'),
            ),
          ),
          footer: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTileBar(
                title: Text(
                  prod.title,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 10),
                ),
                backgroundColor: Colors.black38,
                leading: Consumer<product>(
                  builder: (ctx,products,child)=>
                  IconButton(
                      icon: Icon(products.isFavorite ? Icons.favorite:Icons.favorite_border),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        products.toggleFavorites(authData.token,authData.userId);
                      }),
                ),
                trailing: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      cart.addItem(prod.id, prod.price, prod.title);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Added item to card! '),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: (){
                             cart.removeSingleItem(prod.id);
                          },
                        ),
                      ) );
                    }),
              ),
            ),
          )
      ),
    );
  }
}
