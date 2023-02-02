import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailMatchEnCours extends StatefulWidget {
  String id;

  DetailMatchEnCours(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailMatchEnCours> createState() => _DetailMatchEnCoursState(id);
}

class _DetailMatchEnCoursState extends State<DetailMatchEnCours> {
  String _id;

  _DetailMatchEnCoursState(this._id);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    CollectionReference users = FirebaseFirestore.instance.collection('Matchs');
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Matchs').doc(_id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Row(
              children: [Text("Anonyme")],
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> dataMatch =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
                appBar: AppBar(
                    title: Center(child: Text("Detail du match")),
                    backgroundColor: AppColors.primary),
                body: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(top: 40, right: 5, left: 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset("equipe1.png",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 40),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                          Text("Full-time"),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                          Image.asset("equipe2.png",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 40),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(dataMatch["idEquipe1"],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                          ),
                                          Text(dataMatch["idEquipe2"],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              for (var buteur
                                                  in dataMatch["buteurs1"])
                                                Text(buteur["buteur"]),
                                            ],
                                          ),
                                          ButtonBut(
                                              _id,
                                              dataMatch["score1"],
                                              "score1",
                                              context,
                                              controller,
                                              "buteurs1"),
                                          Text(dataMatch["score1"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("-",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(dataMatch["score2"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                          ButtonBut(
                                              _id,
                                              dataMatch["score2"],
                                              "score2",
                                              context,
                                              controller,
                                              "buteurs2"),
                                          Column(
                                            children: [
                                              for (var buteur
                                                  in dataMatch["buteurs2"])
                                                Text(buteur["buteur"]),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Text("Cartons",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                  )),
                                              Row(
                                                children: [
                                                  ButtonAdd(
                                                      _id,
                                                      dataMatch["yellowCard1"],
                                                      "yellowCard1"),
                                                  Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      color: Colors.yellow,
                                                      child: Center(
                                                          child: Text(
                                                        dataMatch["yellowCard1"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ))),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.001,
                                                  ),
                                                  Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      color: Colors.red,
                                                      child: Center(
                                                          child: Text(
                                                        dataMatch["redCard1"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ))),
                                                  ButtonAdd(
                                                      _id,
                                                      dataMatch["redCard1"],
                                                      "redCard1"),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 10),
                                          Image.asset("ball_football.png",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1,
                                              height: 40),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              Text("Cartons",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                  )),
                                              Row(
                                                children: [
                                                  ButtonAdd(
                                                      _id,
                                                      dataMatch["yellowCard2"],
                                                      "yellowCard2"),
                                                  Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      color: Colors.yellow,
                                                      child: Center(
                                                          child: Text(
                                                        dataMatch["yellowCard2"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ))),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.001,
                                                  ),
                                                  Container(
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      color: Colors.red,
                                                      child: Center(
                                                          child: Text(
                                                        dataMatch["redCard2"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ))),
                                                  ButtonAdd(
                                                      _id,
                                                      dataMatch["redCard2"],
                                                      "redCard2"),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              //en bas
                              Center(
                                  child: Text("Statistique",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(height: 10),
                              Container(
                                  child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ButtonAdd(_id, dataMatch["tirs1"], "tirs1"),
                                    StatistiqueDePlus(
                                      "Total tirs",
                                      "tirs.png",
                                      dataMatch["tirs1"],
                                      dataMatch["tirs2"],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ButtonAdd(_id, dataMatch["tirs2"], "tirs2"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ButtonAdd(_id, dataMatch["tirsCadres1"],
                                        "tirsCadres1"),
                                    StatistiqueDePlus(
                                      "Total tirs cardrés",
                                      "tirs_cadres.png",
                                      dataMatch["tirsCadres1"],
                                      dataMatch["tirsCadres2"],
                                    ),
                                    ButtonAdd(_id, dataMatch["tirsCadres2"],
                                        "tirsCadres2"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ButtonAdd(
                                        _id, dataMatch["fautes1"], "fautes1"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    StatistiqueDePlus(
                                      "Total fautes",
                                      "fautes.webp",
                                      dataMatch["fautes1"],
                                      dataMatch["fautes2"],
                                    ),
                                    ButtonAdd(
                                        _id, dataMatch["fautes2"], "fautes2"),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    ButtonAdd(
                                        _id, dataMatch["corners1"], "corners1"),
                                    StatistiqueDePlus(
                                      "Total corners",
                                      "corners.png",
                                      dataMatch["corners1"],
                                      dataMatch["corners2"],
                                    ),
                                    ButtonAdd(
                                        _id, dataMatch["corners2"], "corners2"),
                                  ],
                                ),
                              )),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      int p1 = 0;
                                      int p2 = 0;
                                      if (dataMatch["score1"] >
                                          dataMatch["score2"]) {
                                        p1 = 3;
                                      } else {
                                        p2 = 3;
                                      }
                                      FirebaseFirestore.instance
                                          .collection("Equipes")
                                          .doc(dataMatch["idEquipe1"])
                                          .update({
                                        "P": p1,
                                        "match": FieldValue.arrayUnion([_id]),
                                      });
                                      FirebaseFirestore.instance
                                          .collection("Equipes")
                                          .doc(dataMatch["idEquipe2"])
                                          .update({
                                        "match": FieldValue.arrayUnion([_id]),
                                        "P": p2,
                                      });
                                    },
                                    child: Text("Fin de match")),
                              )
                            ]))));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

Color _colorIconPlus = Colors.black;
double _sizeIconPlus = 20;
void addToDatabase(String docID, int ancienNombre, String champ) {
  var newNombre = ancienNombre + 1;
  try {
    FirebaseFirestore.instance.collection('Matchs').doc(docID).update({
      '${champ}': newNombre,
    }).then((value) => print("données à jour"));
  } catch (e) {
    print(e.toString());
  }
}

ButtonAdd(_id, int ancienData, String fieldData) {
  return IconButton(
      onPressed: () {
        addToDatabase(_id, ancienData, fieldData);
      },
      icon: Icon(Icons.add),
      color: _colorIconPlus,
      iconSize: _sizeIconPlus);
}

ButtonBut(
  _id,
  int ancienData,
  String fieldData,
  BuildContext context,
  TextEditingController controller,
  String buteur,
) {
  return IconButton(
      onPressed: () {
        addToDatabase(_id, ancienData, fieldData);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Buteur"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Nom du buteur"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    try {
                      FirebaseFirestore.instance
                          .collection("Matchs")
                          .doc(_id)
                          .update({
                        buteur: FieldValue.arrayUnion([
                          {"buteur": controller.value.text}
                        ]),
                      }).then((value) {
                        print("données à jour");
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Text("Modifier"))
            ],
          ),
        );
      },
      icon: Icon(Icons.add),
      color: _colorIconPlus,
      iconSize: _sizeIconPlus);
}

Widget StatistiqueDePlus(String titre, String image, int para1, int para2) {
  return Column(
    children: [
      Image.asset(
        image,
        width: 100,
        height: 40,
      ),
      SizedBox(
        height: 7,
      ),
      Text(titre,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          )),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Text(para1.toString(),
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: 20,
          ),
          Text("-",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: 20,
          ),
          Text(para2.toString(),
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      )
    ],
  );
}
