import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/adminTennis.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/homeHandball.dart';

class NavBarTennisball extends StatelessWidget {
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
          title: Text("Tennisball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homeTennis()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Admin Tennisball"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => adminTennis()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Classement Tennis"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Container()),
            );
          }),
    ]));
  }
}
