import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/screen/ArticleParCategorie.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/interclasse/basket/screen/adminBasketball.dart';
import 'package:tuto_firebase/interclasse/basket/screen/createMatch.dart';
import 'package:tuto_firebase/interclasse/basket/screen/homeBasket.dart';
import 'package:tuto_firebase/interclasse/handball/screen/adminHandball.dart';
import 'package:tuto_firebase/interclasse/handball/screen/homeHandball.dart';
import 'package:tuto_firebase/interclasse/screen/adminFootball.dart';
import 'package:tuto_firebase/interclasse/screen/classementMatch.dart';
import 'package:tuto_firebase/interclasse/screen/homeFootball.dart';
import 'package:tuto_firebase/interclasse/volleyball/screen/adminVolleyball.dart';
import 'package:tuto_firebase/interclasse/volleyball/screen/homeVolley.dart';

class NavBarHandballball extends StatelessWidget {
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
          title: Text("Handball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homeHandball()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Admin Handball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => adminHandball()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Classement Handball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Container()),
            );
          }),
    ]));
  }
}
