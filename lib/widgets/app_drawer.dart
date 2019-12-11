import 'package:flutter/material.dart';


class AppDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text('hello there '),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('shop !'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('orders'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/orders');

          },
        ),

      ],),
    );

  }
}
