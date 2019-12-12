import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/userproduct_item.dart';
import '../widgets/app_drawer.dart';
class UserProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData=Provider.of<ProductProvider>(context);
    return Scaffold(
     appBar: AppBar(
       title: Text('your products'),
       actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: (){

        Navigator.of(context).pushNamed('/editProduct');
        }),
       ],
     ),
      drawer: AppDrawer() ,
      body: Padding(padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: productData.items.length,
        itemBuilder: (context,index)=>Column(
          children: <Widget>[
            UserItem(
              id: productData.items[index].id ,
              title: productData.items[index].title,
              imageUrl: productData.items[index].imageUrl,
            ),
            Divider()
          ],
        ),

      ),),
    );
  }
}
