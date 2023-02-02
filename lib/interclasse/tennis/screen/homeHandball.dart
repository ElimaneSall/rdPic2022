import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/sidebar/nav_drawer_Tennis.dart';
import 'package:tuto_firebase/interclasse/model/match.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/detail_match.dart';
import 'package:tuto_firebase/interclasse/widget/match_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class homeTennis extends StatefulWidget {
  const homeTennis({Key? key}) : super(key: key);

  @override
  State<homeTennis> createState() => _homeTennisState();
}

class _homeTennisState extends State<homeTennis> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference matchs = firestore.collection('Tennis');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Tennis"),
        centerTitle: true,
      ),
      drawer: NavBarTennisball(),
      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Liste des macthes de Tennis récents",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "index_foot.jpg",
                      fit: BoxFit.cover,
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: matchs
                            .orderBy('date', descending: true)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: (snapshot.data! as QuerySnapshot)
                                    .docs
                                    .map((e) => MatchCard(
                                        Matches(
                                            id: e.id,
                                            idUser: e["idUser"],
                                            phase: e["phase"],
                                            buteurs1: e["meilleurbuteurs1"],
                                            buteurs2: e["meilleurbuteurs2"],
                                            equipe1: e['idEquipe1'],
                                            equipe2: e['idEquipe2'],
                                            date: e['date'],
                                            score1: e['score1'],
                                            score2: e['score2'],
                                            likes: e['likes'],
                                            commentaires: e['commentaires']),
                                        () => {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailMatchTennis(
                                                            e.id,
                                                          )))
                                            }))
                                    .toList());
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                  ],
                ),
              ))),
    );
  }
}
