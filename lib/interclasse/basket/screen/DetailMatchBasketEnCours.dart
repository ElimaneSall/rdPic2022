import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/services/notification.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

import '../../handball/screen/DetailMatchHandballEnCours.dart';

class DetailMatchBasketEnCours extends StatefulWidget {
  String id;

  DetailMatchBasketEnCours(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailMatchBasketEnCours> createState() =>
      _DetailMatchBasketEnCoursState(
        id,
      );
}

class _DetailMatchBasketEnCoursState extends State<DetailMatchBasketEnCours> {
  String _id;

  _DetailMatchBasketEnCoursState(
    this._id,
  );
  TextEditingController controller = TextEditingController();

  List<String> _quart_temps = [
    'Premier quart-temps',
    "Deuxième quart-temps",
    'Troisième quart-temps',
    ' Quatrième quart-temps',
  ];
  String? selectedRubrique = "Premier quart-temps";
  TextEditingController scorecontroller1 = TextEditingController();
  TextEditingController scorecontroller2 = TextEditingController();
  TextEditingController nomButeurController = TextEditingController();
  TextEditingController nomButeurController2 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  List userTokens = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userTokens = getUsersId()[1];
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Basket').doc(_id);
    return FutureBuilder<DocumentSnapshot>(
        future: documentReference.get(),
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
                    centerTitle: true,
                    title: Center(
                        child: Text("Détail du match en cours de basket")),
                    backgroundColor: AppColors.primary),
                body: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("equipe2.jpg",
                                        width: 100, height: 40),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4),
                                    Image.asset("equipe1.jpg",
                                        width: 100, height: 40),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(dataMatch["idEquipe1"],
                                      style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6),
                                  Text(dataMatch["idEquipe2"],
                                      style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // ButtonAdd(_id, dataMatch["score1"], "score1",
                                  //     "Basket", 1),
                                  GestureDetector(
                                      child: Icon(Icons.add),
                                      onTap: () {
                                        OpenDialogBut(
                                            context,
                                            controller,
                                            _id,
                                            "Basket",
                                            "score1",
                                            dataMatch["score1"]);
                                        documentReference = FirebaseFirestore
                                            .instance
                                            .collection('Basket')
                                            .doc(_id);
                                      }),
                                  Text(dataMatch["score1"].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                  Text("-",
                                      style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                  Text(dataMatch["score2"].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  GestureDetector(
                                      child: Icon(Icons.add),
                                      onTap: () {
                                        OpenDialogBut(
                                            context,
                                            controller,
                                            _id,
                                            "Basket",
                                            "score2",
                                            dataMatch["score2"]);
                                        setState(() {
                                          documentReference = FirebaseFirestore
                                              .instance
                                              .collection('Basket')
                                              .doc(_id);
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(dataMatch["meilleurbuteurs1"]
                                              ["nom"]),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(dataMatch["meilleurbuteurs1"]
                                                  ["points"]
                                              .toString()),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(dataMatch["meilleurbuteurs2"]
                                              ["nom"]),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(dataMatch["meilleurbuteurs2"]
                                                  ["points"]
                                              .toString()),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var set in dataMatch["quarts"])
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(set["quart"]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(set["quartScore1"].toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                )),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text("-",
                                                style: TextStyle(
                                                    color: AppColors.blue,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(set["quartScore1"].toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                )),
                                          ],
                                        )
                                      ],
                                    )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("ball_football.png",
                                      width: 100, height: 40),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Fin quart-temps"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      side: BorderSide(
                                                          color: Colors.white)),
                                                  title: Row(children: [
                                                    // Text('Quart-temps: '),
                                                    DropdownButton(
                                                      value: selectedRubrique,
                                                      items: _quart_temps
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                child:
                                                                    Text(item),
                                                                value: item,
                                                              ))
                                                          .toList(),
                                                      onChanged: (item) =>
                                                          setState(() =>
                                                              selectedRubrique =
                                                                  item
                                                                      as String),
                                                    )
                                                  ]),
                                                ),
                                                TextField(
                                                  controller: scorecontroller1,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Score de l'équipe 1"),
                                                ),
                                                TextField(
                                                  controller: scorecontroller2,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Score de l'équipe 2"),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    try {
                                                      FirebaseFirestore.instance
                                                          .collection("Basket")
                                                          .doc(_id)
                                                          .update({
                                                        "quarts": FieldValue
                                                            .arrayUnion([
                                                          {
                                                            "quartScore1":
                                                                int.parse(
                                                                    scorecontroller1
                                                                        .value
                                                                        .text),
                                                            "quartScore2":
                                                                int.parse(
                                                                    scorecontroller2
                                                                        .value
                                                                        .text),
                                                            "quart":
                                                                selectedRubrique
                                                          }
                                                        ]),
                                                      }).then((value) {
                                                        print("données à jour");
                                                        Navigator.pop(context);
                                                      });
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                  child:
                                                      Text("Fin quart-temps"))
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text("Fin quart-temps"))),
                              Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black),
                                      onPressed: () {
                                        MeilleurButteurDialog(
                                            context,
                                            controller,
                                            nomButeurController,
                                            controller2,
                                            nomButeurController2,
                                            _id,
                                            "Basket");
                                      },
                                      child: Text("Fin du Match"))),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            ButtonAdd(_id, dataMatch["rebond1"],
                                                "rebond1", "Basket", 1),
                                            StatistiqueDePlus(
                                              "Rebonds",
                                              "tirs.png",
                                              dataMatch["rebond1"],
                                              dataMatch["rebond2"],
                                            ),
                                            ButtonAdd(_id, dataMatch["rebond2"],
                                                "rebond2", "Basket", 1),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            ButtonAdd(_id, dataMatch["fautes1"],
                                                "fautes1", "Basket", 1),
                                            StatistiqueDePlus(
                                              "Fautes",
                                              "tirs_cadres.png",
                                              dataMatch["fautes1"],
                                              dataMatch["fautes2"],
                                            ),
                                            ButtonAdd(_id, dataMatch["fautes2"],
                                                "fautes2", "Basket", 1),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            ButtonAdd(
                                                _id,
                                                dataMatch["fautesIndiv1"],
                                                "fautesIndiv1",
                                                "Basket",
                                                1),
                                            StatistiqueDePlus(
                                              "Fautes Individuelles",
                                              "fautes.webp",
                                              dataMatch["fautesIndiv1"],
                                              dataMatch["fautesIndiv2"],
                                            ),
                                            ButtonAdd(
                                                _id,
                                                dataMatch["fautesIndiv2"],
                                                "fautesIndiv2",
                                                "Basket",
                                                1),
                                            SizedBox(
                                              width: 30,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 40,
                                      color: AppColors.primary,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                addLikes(_id, "Basket",
                                                    dataMatch["likes"]);
                                              },
                                              child: Icon(
                                                Icons.thumb_up,
                                                color: Colors.white,
                                              )),
                                          // SizedBox(height: 10,),
                                          Text(
                                            dataMatch["likes"].toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),

                                          GestureDetector(
                                              onTap: () {
                                                undLike(_id, "Basket",
                                                    dataMatch["unlikes"]);
                                              },
                                              child: Icon(
                                                Icons.thumb_down,
                                                color: Colors.white,
                                              )),
                                          // SizedBox(height: 10,),
                                          Text(
                                            dataMatch["unlikes"].toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          InkWell(
                                              child: Text(
                                                "Commenter",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              onTap: () {
                                                commentOpenDiallog(context,
                                                    controller, _id, "Basket");
                                              }),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          ),
                                          InkWell(
                                              child: Text(
                                                "Partager",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                              onTap: () {})
                                        ],
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Commentaires",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  for (final commentaire
                                      in dataMatch["commentaires"])
                                    Column(children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<DocumentSnapshot>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(
                                                          commentaire["idUser"])
                                                      .get(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot>
                                                          snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          "Something went wrong");
                                                    }

                                                    if (snapshot.hasData &&
                                                        !snapshot
                                                            .data!.exists) {
                                                      return Text(
                                                          "Document does not exist");
                                                    }

                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      Map<String, dynamic>
                                                          dataUser =
                                                          snapshot.data!.data()
                                                              as Map<String,
                                                                  dynamic>;
                                                      //  role = dataUser["role"];
                                                      return Container(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                      radius:
                                                                          20,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                        dataUser[
                                                                            "urlProfile"],
                                                                      )),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            dataUser["prenom"],
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            dataUser["nom"],
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(timeAgoCustom(DateTime.parse(commentaire[
                                                                              'date']
                                                                          .toDate()
                                                                          .toString())))
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ));
                                                    }
                                                    return Text("Anonyme");
                                                  }),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(commentaire[
                                                      'commentaire']),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    timeAgoCustom(
                                                        DateTime.parse(
                                                            commentaire['date']
                                                                .toDate()
                                                                .toString())),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ])
                                ],
                              )
                            ]))));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
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
                  color: AppColors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: 20,
          ),
          Text("-",
              style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: 20,
          ),
          Text(para2.toString(),
              style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      )
    ],
  );
}

ButtonBut(
  List tokens,
  _id,
  int ancienData,
  String fieldData,
  BuildContext context,
  TextEditingController controller,
) {
  return IconButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Score"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Nombre de points marqués"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    try {
                      FirebaseFirestore.instance
                          .collection("Basket")
                          .doc(_id)
                          .update({
                        "qartss"[1]: FieldValue.arrayUnion([
                          {
                            "score1": 10,
                          }
                        ])
                      }).then((value) {
                        print("données à jour");

                        for (var e in tokens) {
                          sendPushMessage(e, "Veuillez consulter le match",
                              "Interclasse: Un nouveau but");
                        }
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
      color: Colors.black,
      iconSize: 25);
}
