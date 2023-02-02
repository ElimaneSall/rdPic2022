import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/screen/ArticleParCategorie.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/interclasse/basket/screen/createMatch.dart';
import 'package:tuto_firebase/interclasse/basket/screen/homeBasket.dart';
import 'package:tuto_firebase/interclasse/screen/adminFootball.dart';
import 'package:tuto_firebase/interclasse/screen/classementMatch.dart';
import 'package:tuto_firebase/interclasse/screen/homeFootball.dart';

class NavBarFootball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
          accountName: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          accountEmail: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://pbs.twimg.com/profile_images/1600049665789108224/ZaL59hjV_400x400.jpg"),
                  fit: BoxFit.cover))),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Home"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeApp()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Footbal"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeFootball()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Admin Football"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminFootball()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Classement Football"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassementMatch()),
            );
          }),
    ]));
  }
}
