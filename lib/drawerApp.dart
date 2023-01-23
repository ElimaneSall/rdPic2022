import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/screen/HomeSOS.dart';
import 'package:tuto_firebase/annonce/screen/homeAnnonce.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';
import 'package:tuto_firebase/interclasse/screen/homeInterClasse.dart';
import 'package:tuto_firebase/jeux/screen/Home.dart';
import 'package:tuto_firebase/login/GetFile.dart';
import 'package:tuto_firebase/login/PageTest.dart';
import 'package:tuto_firebase/login/profile.dart';
import 'package:tuto_firebase/login/signIn.dart';
import 'package:tuto_firebase/pShop/screen/HomeUserPshop.dart';

import 'blog/screen/RD.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
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
            "Profil",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text(
            "Polytech Info",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeAnnonce()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Blog"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeArticle()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Interclasse"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeInterClasse()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("SOS EPT"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeSOS()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("PShop"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeUserPshop()));
            //Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => RD(categorie)),
            // );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Jeux"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChessGame()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Page Test"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRCodeDetect()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Deconnecter"),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Deconnecter");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          }),
    ]));
  }
}
