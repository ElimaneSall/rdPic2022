import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/homeApp.dart';
import '../utils/color/color.dart';
import '../widget/reusableTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _promoTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _password2TextController = TextEditingController();
  TextEditingController _classeTextController = TextEditingController();

  String? mtoken;
  void _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      // saveToken(token!);
    });
  }

  // void saveToken(String token) async {
  //   await FirebaseFirestore.instance
  //       .collection("UserToken")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set({
  //     "token": token,
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    getToken();
  }

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
                          "Entrer votre numéro de téléphone ",
                          Icons.person_outline,
                          false,
                          _phoneTextController,
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
                      reusableTextField(
                          "Entrer votre classe ",
                          Icons.person_outline,
                          false,
                          _classeTextController,
                          Colors.white),
                      SizedBox(
                        height: 20,
                      ),
                      signInSignUpButton("S'inscrire", context, false,
                          () async {
                        print("MailBi");
                        print(_emailTextController.value.text.split("@")[1]);
                        if (_emailTextController.value.text.split("@")[1] ==
                            "ept.sn") {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) async {
                            print("SaveToken");
                            //  saveToken(mtoken!);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                                'email', _emailTextController.value.text);
                            prefs.setString(
                                'password', _passwordTextController.value.text);
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser!.uid
                                    .toString())
                                .set({
                              'email': _emailTextController.value.text,
                              'promo': _promoTextController.value.text,
                              'nom': _nameTextController.value.text,
                              "prenom": _userNameTextController.value.text,
                              "telephone": _phoneTextController.value.text,
                              'admin': false,
                              "role": "user",
                              "classe": _classeTextController.value.text,
                              "urlProfile":
                                  "https://w7.pngwing.com/pngs/798/436/png-transparent-computer-icons-user-profile-avatar-profile-heroes-black-profile-thumbnail.png",
                              "token": mtoken,
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
                        } else {
                          final snackBar = SnackBar(
                              content: const Text("Le mail n'est pas valide"),
                              action: SnackBarAction(
                                label: 'Réessayer',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          print("Le mail n'est pas valide");
                        }
                      }),
                    ])))));
  }
}
