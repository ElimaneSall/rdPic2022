import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/login/signUp.dart';
import 'package:tuto_firebase/pShop/screen/HomeShopkeeperPshop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/color/color.dart';
import '../widget/reusableTextField.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

late String role;

class _SignInState extends State<SignIn> {
  late TextEditingController _emailTextController = TextEditingController();
  late TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        hexStringToColor("000"),
        hexStringToColor("000"),
        hexStringToColor("dd9933"),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.height * 0.2, 20, 0),
        child: Column(children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              "https://pbs.twimg.com/profile_images/1600049665789108224/ZaL59hjV_400x400.jpg",
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.6,
              height: 240,

              // color: Colors.white,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          reusableTextField("Entrer votre mail", Icons.person_outline, false,
              _emailTextController, Colors.white),
          SizedBox(
            height: 30,
          ),
          reusableTextField("Entrer votre mot de passe", Icons.lock, true,
              _passwordTextController, Colors.white),
          signInSignUpButton("Se Connecter", context, true, () {
            FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text)
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeApp()));
                  }
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeApp()));
                }
              });
            });
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "J'ai pas de compte ",
                style: TextStyle(color: Colors.white70),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ]),
      )),
    ));
  }
}
