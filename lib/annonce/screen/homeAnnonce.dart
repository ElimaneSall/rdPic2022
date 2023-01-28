import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';
import 'package:tuto_firebase/annonce/screen/annonceList.dart';
import 'package:tuto_firebase/annonce/screen/evenementsList.dart';

import 'package:tuto_firebase/annonce/sideBar/sideBar.dart';
import 'package:tuto_firebase/annonce/widget/annonceCard.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class HomeAnnonce extends StatefulWidget {
  const HomeAnnonce({Key? key}) : super(key: key);

  @override
  State<HomeAnnonce> createState() => _HomeAnnonceState();
}

class _HomeAnnonceState extends State<HomeAnnonce> {
  Future getImageFromFirebase() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection("Evenement").get();
    return qn.docs;
  }

  final Stream<QuerySnapshot> _evenementStream =
      FirebaseFirestore.instance.collection('Evenement').snapshots();
  final Stream<QuerySnapshot> _annonceStream = FirebaseFirestore.instance
      .collection('Annonce')
      .orderBy("date", descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
            "Polytech Info",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: _evenementStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 300,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              //onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Builder(
                                builder: (BuildContext context) {
                                  return Column(children: [
                                    Container(
                                        height: 235,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: Colors.white),
                                        child: Image.network(data["image"])),
                                    Text(data["titre"]),
                                  ]);
                                },
                              );
                            }).toList(),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 135,
                                  height: 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnnonceList()),
                                        );
                                      },
                                      child: Text(
                                        "Annonce",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ))),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                  width: 135,
                                  height: 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EvenementList()),
                                        );
                                      },
                                      child: Text(
                                        "Evenement",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )))
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Les annonces recentes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          //SizedBox(height: ,),

                          Row(
                            children: [
                              Container(
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                color: Colors.blue,
                              ),
                            ],
                          )
                        ])));
              }),
          SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _annonceStream,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: (snapshot.data! as QuerySnapshot)
                              .docs
                              .map((e) => AnnonceCard(Annonce(
                                    id: e.id,
                                    likes: e['likes'],
                                    unlikes: e['unlikes'],
                                    commentaires: e['commentaires'],
                                    titre: e['titre'],
                                    poste: e['poste'],
                                    date: e['date'],
                                    status: e['status'],
                                    // description: e['description'],
                                    auteur: e['auteur'],
                                    annonce: e['annonce'],
                                    // likes: e['likes']
                                  )))
                              .toList());
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))
        ])));
  }
}
