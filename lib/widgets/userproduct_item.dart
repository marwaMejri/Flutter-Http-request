import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  UserItem({this.title, this.imageUrl});
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
                icon: Icon(Icons.edit), color: Colors.red, onPressed: () {}),
            IconButton(
                icon: Icon(Icons.delete), color: Colors.red, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
