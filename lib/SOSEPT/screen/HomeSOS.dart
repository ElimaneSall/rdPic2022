import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/model/SOSModel.dart';
import 'package:tuto_firebase/SOSEPT/model/widget/RepondreSOS.dart';
import 'package:tuto_firebase/SOSEPT/model/widget/SOSCard.dart';
import 'package:tuto_firebase/SOSEPT/screen/LancerSOS.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import '../../annonce/model/annonce.dart';
import '../../annonce/widget/annonceCard.dart';

class HomeSOS extends StatefulWidget {
  const HomeSOS({Key? key}) : super(key: key);

  @override
  State<HomeSOS> createState() => _HomeSOSState();
}

class _HomeSOSState extends State<HomeSOS> {
  @override
  Widget build(BuildContext context) {
    String group = "47";
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        print(documentSnapshot["promo"]);
        group = documentSnapshot["promo"];
      } else {
        print('Document does not exist on the database');
      }
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Stream<QuerySnapshot> products = firestore.collection('SOS').where(
      "groupe",
      whereIn: ["tout", group],
    ).snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("SOS EPT")),
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeApp()));
          },
          child: Icon(Icons.home // add custom icons also
              ),
        ),
      ),

      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        child: Column(
          children: [
            Center(
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                            "Vous avez perdu une chose ou vous demandez de l’aide, Cliquer sur ce buton "),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LancerSOS()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              child: Center(
                                  child: Text(
                                "Lancer un SOS",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              )))),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Image.asset(
                    "sos.png",
                    fit: BoxFit.cover,
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.42,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 22,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: products,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        color: AppColors.background,
                        child: Column(
                            children: (snapshot.data! as QuerySnapshot)
                                .docs
                                .map((e) => SOSCard(SOSModel(
                                    id: e.id,
                                    sos: e['sos'],
                                    reponse: e['reponses'],
                                    idAuteur: e['idAuteur'],
                                    date: e["date"]

                                    // likes: e['likes']
                                    )))
                                .toList()));
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ))),
      floatingActionButton: FloatingActionButton(
        elevation: 30.0,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LancerSOS()),
          );
        },
      ),
    );
  }
}
