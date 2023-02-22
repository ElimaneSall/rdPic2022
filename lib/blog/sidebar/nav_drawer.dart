import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/screen/ArticleParCategorie.dart';
import 'package:tuto_firebase/blog/screen/addArticle.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';
import 'package:tuto_firebase/homeApp.dart';

class NavBar extends StatelessWidget {
  String role;
  NavBar(this.role, {Key? key}) : super(key: key);

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
      if (role == "adminBlog" || role == "admin")
        ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Admin"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddArticle()),
              );
            }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Home Blog"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeArticle()),
            );
          }),
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
          title: Text("Polytech News"),
          onTap: () {
            final categorie = 'Polytech  News';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Recherche Et Développement"),
          onTap: () {
            final categorie = 'Recherche et Développement';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Environnement"),
          onTap: () {
            final categorie = 'Cellule Environnement';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.settings),
          title: Text("Cellule Mécanique"),
          onTap: () {
            final categorie = 'Celulle Mécanique';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(
            Icons.airplane_ticket,
          ),
          title: Text("Cellule Aéronautique"),
          onTap: () {
            final categorie = " 'Celulle Aéro',";
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.house),
          title: Text("Cellule Genie Civil"),
          onTap: () {
            final categorie = 'Cellule Civil';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Cellule Genie Industriel"),
          onTap: () {
            final categorie = 'Cellule Genie Industriel';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Club Anglais"),
          onTap: () {
            final categorie = "anglais";
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Sous-commission RAMA"),
          onTap: () {
            final categorie = "Sous-commission Rama";
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          }),
      ListTile(
          leading: Icon(Icons.health_and_safety),
          title: Text("Sous-commission Sante"),
          onTap: () {
            final categorie = 'Sous-commission Santé';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleParCategorie(categorie, role)),
            );
          })
    ]));
  }
}
