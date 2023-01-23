import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/screen/RD.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/interclasse/screen/adminFootball.dart';
import 'package:tuto_firebase/interclasse/screen/classementMatch.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
          accountName: Text(
            "Elimane Sall",
            style: TextStyle(color: Colors.black),
          ),
          accountEmail: Text(
            "test@test.com",
            style: TextStyle(color: Colors.black),
          ),
          currentAccountPicture: CircleAvatar(
              child: ClipOval(
            child: Image.network(
              "https://i.pinimg.com/736x/a6/ed/de/a6edde7bcdeda1871114d23aa7d53b18.jpg",
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          )),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://i.pinimg.com/736x/a6/ed/de/a6edde7bcdeda1871114d23aa7d53b18.jpg"),
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
            final categorie = "RD";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
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
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("BasketBall"),
          onTap: () {
            final categorie = "RD";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("VolleyBall"),
          onTap: () {
            final categorie = "RD";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("HandBall"),
          onTap: () {
            final categorie = "Environnement";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Genie en Herbe"),
          onTap: () {
            final categorie = "Environnement";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Athletisme"),
          onTap: () {
            final categorie = "Environnement";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
    ]));
  }
}
