import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailMatch extends StatefulWidget {
  String id;

  DetailMatch(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailMatch> createState() => _DetailMatchState(
        id,
      );
}

class _DetailMatchState extends State<DetailMatch> {
  String _id;

  _DetailMatchState(
    this._id,
  );
  TextEditingController controller = TextEditingController();
  final Stream<QuerySnapshot> _articleStream =
      FirebaseFirestore.instance.collection('Matchs').snapshots();

  @override
  Widget build(BuildContext context) {
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
                        padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("equipe1.png",
                                        width: 100, height: 40),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4),
                                    Image.asset("equipe2.png",
                                        width: 100, height: 40),
                                  ]),

                              // Text(dataMatch["idEquipe1"],
                              //     style: TextStyle(
                              //         color: AppColors.blue,
                              //         fontSize: 30,
                              //         fontWeight: FontWeight.bold)),
                              // SizedBox(
                              //   height: 30,
                              // ),
                              // Text("Cartons",
                              //     style: TextStyle(
                              //       color: AppColors.blue,
                              //       fontSize: 20,
                              //     )),
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
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      for (var buteur in dataMatch["buteurs1"])
                                        Text(buteur["buteur"]),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1),
                                  Column(
                                    children: [
                                      for (var buteur in dataMatch["buteurs2"])
                                        Text(buteur["buteur"]),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text("Cartons",
                                              style: TextStyle(
                                                color: AppColors.blue,
                                                fontSize: 20,
                                              )),
                                          Row(
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width: 30,
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
                                                width: 5,
                                              ),
                                              Container(
                                                  height: 40,
                                                  width: 30,
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
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text("Cartons",
                                              style: TextStyle(
                                                color: AppColors.blue,
                                                fontSize: 20,
                                              )),
                                          Row(
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width: 30,
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
                                                width: 5,
                                              ),
                                              Container(
                                                  height: 40,
                                                  width: 30,
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
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
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
                                            StatistiqueDePlus(
                                              "Total tirs",
                                              "tirs.png",
                                              dataMatch["tirs1"],
                                              dataMatch["tirs2"],
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            StatistiqueDePlus(
                                              "Total tirs cardrés",
                                              "tirs_cadres.png",
                                              dataMatch["tirsCadres1"],
                                              dataMatch["tirsCadres2"],
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            StatistiqueDePlus(
                                              "Total fautes",
                                              "fautes.webp",
                                              dataMatch["fautes1"],
                                              dataMatch["fautes2"],
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            StatistiqueDePlus(
                                              "Total corners",
                                              "corners.png",
                                              dataMatch["corners1"],
                                              dataMatch["corners2"],
                                            ),
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
                                                addLikes(_id, "Evenement",
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
                                                undLike(_id, "Evenement",
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
                                                commentOpenDiallog(
                                                    context,
                                                    controller,
                                                    _id,
                                                    "Evenement");
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
