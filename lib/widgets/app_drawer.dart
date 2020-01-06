import 'package:app3/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: (){
            Navigator.of(context).pushReplacementNamed('/userproduct');

          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context,listen: false).logout();
          },
        ),

      ],),
    );

  }
}
