import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/screen/HomeSOS.dart';
import 'package:tuto_firebase/annonce/screen/homeAnnonce.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';

import 'package:tuto_firebase/drawerApp.dart';
import 'package:tuto_firebase/interclasse/home/homeInterClasse.dart';
import 'package:tuto_firebase/interclasse/screen/homeFootball.dart';
import 'package:tuto_firebase/jeux/screen/Home.dart';
import 'package:tuto_firebase/pShop/screen/HomeUserPshop.dart';
import 'package:tuto_firebase/screen/homeScreen.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

// ignore: non_constant_identifier_names
Widget CardHome(BuildContext context, String image, String titre,
    Widget Function() redirection) {
  var _size = 20.0;

  return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => redirection()),
        );
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage(
                  image,
                ),
                opacity: 0.7,
                fit: BoxFit.fill),
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03),
                child: Text(
                  titre,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: _size,
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.77),
                  child: Icon(
                    Icons.arrow_right,
                    size: _size * 3,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ));
}

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    var _size = 20.0;
    return Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(child: Text("Hub des applis de l'EPT")),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 50),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CardHome(context, "index_foot.jpg", "Interclasse",
                  () => HomeInterClasse()),
              SizedBox(height: 30),
              CardHome(context, "Pshop.png", "P-shop", () => HomeUserPshop()),
              SizedBox(height: 30),
              CardHome(context, "polytechInfo.png", "Polytech Info",
                  () => HomeAnnonce()),
              SizedBox(height: 30),
              CardHome(context, "sosLogo.png", "SOS EPT", () => HomeSOS()),
              SizedBox(height: 30),
              CardHome(context, "blog.png", "Blog", () => HomeArticle()),
              SizedBox(height: 30),
              CardHome(context, "echec.png", "Jeux", () => ChessGame()),
              SizedBox(height: 30),
            ],
          ),
        )));
  }
}
