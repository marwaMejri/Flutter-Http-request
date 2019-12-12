import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
class UserItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;
  UserItem({this.title, this.imageUrl,this.id});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit), color: Colors.red, onPressed: () {
                  Navigator.of(context).pushNamed('/editProduct',arguments: id);

            }),
            IconButton(
                icon: Icon(Icons.delete), color: Colors.red, onPressed: () {

                  Provider.of<ProductProvider>(context,listen: false).deleteProduct(id);

            }),
          ],
        ),
      ),
    );
  }
}
