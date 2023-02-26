import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/screen/ArticleParCategorie.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/interclasse/basket/screen/createMatch.dart';
import 'package:tuto_firebase/interclasse/basket/screen/homeBasket.dart';
import 'package:tuto_firebase/interclasse/football/screen/homeFootball.dart';
import 'package:tuto_firebase/interclasse/handball/screen/homeHandball.dart';
import 'package:tuto_firebase/interclasse/volleyball/screen/homeVolley.dart';

class NavBar extends StatelessWidget {
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
                  image: AssetImage(
                    "assets/images/logoBDE.jpg",
                  ),
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
          title: Text("BasketBall"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeBasket()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Genie en Herbe"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Container()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Volleyball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeVolley()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Handball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homeHandball()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Tennis"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Container()),
            );
          }),
    ]));
  }
}
