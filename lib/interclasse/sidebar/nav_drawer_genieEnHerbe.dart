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
import 'package:tuto_firebase/interclasse/genieEnHerbe/screen/adminGenieEnHerbe.dart';
import 'package:tuto_firebase/interclasse/genieEnHerbe/screen/homeGenieEnHerbe.dart';

import '../genieEnHerbe/screen/classementMatch.dart';

class NavBarGenieEnHerbeball extends StatelessWidget {
  String role;
  NavBarGenieEnHerbeball(this.role);

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
          title: Text("Génie en herbe"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeGenieEnHerbe()),
            );
          }),
      if (role == "adminGenieEnHerbe" || role == "admin")
        ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Admin Genie en herbe"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminGenieEnHerbe()),
              );
            }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Classement Genie en herbe"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassementMatch()),
            );
          }),
    ]));
  }
}
