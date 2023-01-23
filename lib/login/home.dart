import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/login/signIn.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
      child: Text("Logout"),
      onPressed: () {
        FirebaseAuth.instance.signOut().then((value) {
          print("Deconnecter");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignIn()));
        });
      },
    )));
  }
}
