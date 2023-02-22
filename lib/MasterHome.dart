import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/login/signIn.dart';
import 'package:tuto_firebase/pShop/screen/HomeShopkeeperPshop.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class MasterHome extends StatefulWidget {
  const MasterHome({super.key});

  @override
  State<MasterHome> createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHome> {
  _connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    if (email != null && password != null) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(value.user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            if (documentSnapshot.get("role") == "boutiquier") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeShopkeeperPshop()));
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeApp()));
            }
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignIn()));
          }
        });
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
    ;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(colors: [
              //   hexStringToColor("000"),
              //   hexStringToColor("000"),
              //   hexStringToColor("dd9933"),
              // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, MediaQuery.of(context).size.height * 0.5, 20, 0),
                      child: Column(children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            "assets/images/logoBDE.jpg",
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),
                      ]))))),
    );
  }
}
