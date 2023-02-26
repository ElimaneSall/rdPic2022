import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/interclasse/basket/screen/homeBasket.dart';
import 'package:tuto_firebase/interclasse/football/screen/homeFootball.dart';
import 'package:tuto_firebase/interclasse/genieEnHerbe/screen/homeGenieEnHerbe.dart';
import 'package:tuto_firebase/interclasse/handball/screen/homeHandball.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/homeHandball.dart';
import 'package:tuto_firebase/interclasse/volleyball/screen/homeVolley.dart';
import 'package:tuto_firebase/interclasse/widget/match_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import '../sidebar/nav_drawer_interclasse.dart';

class HomeInterClasse extends StatefulWidget {
  const HomeInterClasse({Key? key}) : super(key: key);

  @override
  State<HomeInterClasse> createState() => _HomeInterClasseState();
}

class _HomeInterClasseState extends State<HomeInterClasse> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference matchs = firestore.collection('Matchs');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Interclasse"),
        centerTitle: true,
      ),
      drawer: NavBar(),
      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CardHome(context, "index_foot.jpg", "Football",
                        () => HomeFootball()),
                    SizedBox(height: 30),
                    CardHome(context, "genieEnHerbe.jpg", "Génie en herbe",
                        () => HomeGenieEnHerbe()),
                    SizedBox(height: 30),
                    CardHome(context, "basketballLogo.jpg", "Basketball",
                        () => HomeBasket()),
                    SizedBox(height: 30),
                    CardHome(context, "handballLogo.jpg", "Handball",
                        () => homeHandball()),
                    SizedBox(height: 30),
                    CardHome(context, "volleyball.jpg", "Volleyball",
                        () => HomeVolley()),
                    SizedBox(height: 30),
                    CardHome(
                        context, "tennis.jpg", "Tennis", () => homeTennis()),
                    SizedBox(height: 30),
                  ],
                ),
              ))),
    );
  }
}
