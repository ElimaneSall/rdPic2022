import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/interclasse/handball/screen/detail_match.dart';
import 'package:tuto_firebase/interclasse/home/homeInterClasse.dart';
import 'package:tuto_firebase/interclasse/model/match.dart';
import 'package:intl/intl.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/DetailMatchTennisEnCours.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/createMatch.dart';
import 'package:tuto_firebase/interclasse/widget/match_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class adminTennis extends StatefulWidget {
  const adminTennis({Key? key}) : super(key: key);

  @override
  State<adminTennis> createState() => _adminTennisState();
}

class _adminTennisState extends State<adminTennis> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> products =
        FirebaseFirestore.instance.collection('Tennis').where(
      "idEquipe1",
      whereIn: ["47"],
    ).snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Admin Tennis"),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeInterClasse()));
          },
          child: Icon(Icons.home // add custom icons also
              ),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Text("Match en cours"),
          StreamBuilder<QuerySnapshot>(
              stream: products,
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
                                  equipe1: e['idEquipe1'],
                                  buteurs1: e["meilleurbuteurs1"],
                                  buteurs2: e["meilleurbuteurs2"],
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
                                                DetailMatchTennisEnCours(
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
      )),
      floatingActionButton: FloatingActionButton(
        elevation: 30.0,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTennisMatch()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
