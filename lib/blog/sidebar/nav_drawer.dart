import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/screen/RD.dart';
import 'package:tuto_firebase/blog/screen/addArticle.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';
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
          title: Text("Admin"),
          onTap: () {
            final categorie = "RD";
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
            final categorie = "PN";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Recherche Et Developpement"),
          onTap: () {
            final categorie = "RD";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Environnement"),
          onTap: () {
            final categorie = "environnement";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.settings),
          title: Text("Cellule Meca"),
          onTap: () {
            final categorie = "meca";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(
            Icons.airplane_ticket,
          ),
          title: Text("Cellule Aeronautique"),
          onTap: () {
            final categorie = "aero";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.house),
          title: Text("Cellule Genie Civil"),
          onTap: () {
            final categorie = "civil";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Cellule Genie Industriel"),
          onTap: () {
            final categorie = "GI";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Club Anglais"),
          onTap: () {
            final categorie = "anglais";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Sous-commission RAMA"),
          onTap: () {
            final categorie = "RAMA";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          }),
      ListTile(
          leading: Icon(Icons.health_and_safety),
          title: Text("Sous-commission Sante"),
          onTap: () {
            final categorie = "sante";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RD(categorie)),
            );
          })
    ]));
  }
}
