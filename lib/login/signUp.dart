import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/homeApp.dart';
import '../utils/color/color.dart';
import '../widget/reusableTextField.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _promoTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _password2TextController = TextEditingController();
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
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Entrer votre nom ",
                          Icons.person_outline,
                          false,
                          _nameTextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Entrer votre prenom ",
                          Icons.person_outline,
                          false,
                          _userNameTextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Entrer votre Email",
                          Icons.person_outline,
                          false,
                          _emailTextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Entrer votre mot de passe",
                          Icons.person_outline,
                          false,
                          _passwordTextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Retaper votre mot de passe",
                          Icons.person_outline,
                          false,
                          _password2TextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Entrer votre promo ",
                          Icons.person_outline,
                          false,
                          _promoTextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      signInSignUpButton("S'inscrire", context, false, () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .set({
                            'email': _emailTextController.value.text,
                            'promo': _promoTextController.value.text,
                            'nom': _nameTextController.value.text,
                            "prenom": _userNameTextController.value.text,
                            'admin': false,
                            "role": "user",
                            "urlProfile": "",
                            "id": FirebaseAuth.instance.currentUser!.uid
                                .toString()
                          });
                          print("account creating success");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeApp()));
                        }).onError((error, stackTrace) {
                          print("Error" + error.toString());
                        });
                      }),
                    ])))));
  }
}
