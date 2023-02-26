import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/interclasse/football/model/match.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MatchCard extends StatelessWidget {
  final Matches match;
  Function function;
  String _collection;
  MatchCard(this.match, this.function, this._collection);
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    return InkWell(
        onLongPress: () {
          if (FirebaseAuth.instance.currentUser!.uid == match.idUser) {
            openDialogDelete(context, match.id, _collection,
                "Message de suppression", "Voulez vous supprimer ce match");
          }
        },
        onTap: () {
          function();
        },
        child: Padding(
            padding: EdgeInsets.only(bottom: 10, left: 10),
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      // height: 80,
                      decoration: BoxDecoration(
                          color: AppColors.tertiare,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  match.equipe1,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "vs",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  match.equipe2,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  match.score1.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                ),
                                Text(
                                  match.score2.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              match.phase,
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                    ),
                    Container(
                      //  height: 60,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dateCustomformat(DateTime.parse(
                                  match.date.toDate().toString())),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )
                          ]),
                    )
                  ],
                ))));
  }
}
