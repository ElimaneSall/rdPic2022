import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/screen/annonceList.dart';
import 'package:tuto_firebase/annonce/screen/evenementsList.dart';
import 'package:tuto_firebase/annonce/screen/postAdmin.dart';
import 'package:tuto_firebase/annonce/screen/postAdminEvenement.dart';
import 'package:tuto_firebase/blog/screen/RD.dart';
import 'package:tuto_firebase/homeApp.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

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
          title: Text(
            "Home",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeApp()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Annonce"),
          onTap: () {
            //final categorie = "annonce";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnnonceList()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Evenement"),
          onTap: () {
            // final categorie = "evenement";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EvenementList()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Faire une annonce"),
          onTap: () {
            //final categorie = "annonce";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostAdmin()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Poster un evenement"),
          onTap: () {
            //final categorie = "annonce";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostAdminEvenement()),
            );
          }),
    ]));
  }
}
