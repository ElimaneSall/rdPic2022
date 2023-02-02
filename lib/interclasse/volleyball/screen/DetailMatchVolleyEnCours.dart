import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailMatchVolleyEnCours extends StatefulWidget {
  String id;

  DetailMatchVolleyEnCours(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailMatchVolleyEnCours> createState() =>
      _DetailMatchVolleyEnCoursState(
        id,
      );
}

class _DetailMatchVolleyEnCoursState extends State<DetailMatchVolleyEnCours> {
  String _id;

  _DetailMatchVolleyEnCoursState(
    this._id,
  );
  TextEditingController controller = TextEditingController();
  final Stream<QuerySnapshot> _articleStream =
      FirebaseFirestore.instance.collection('Volley').snapshots();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Volley').doc(_id).get(),
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
                    title: Center(child: Text("Détail du match")),
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
                                  ButtonAdd(_id, dataMatch["score1"], "score1",
                                      "Volley", 1),
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
                                  ButtonAdd(_id, dataMatch["score2"], "score2",
                                      "Volley", 1),
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

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5),
                                  Row(
                                    children: [],
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
                                height: 10,
                              ),

                              Column(
                                children: [
                                  Text("Quart-temps 1"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(dataMatch["score1"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text("-",
                                          style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text(dataMatch["score2"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Text("Quart-temps 2"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(dataMatch["score1"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text("-",
                                          style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text(dataMatch["score2"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Text("Quart-temps 3"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(dataMatch["score1"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text("-",
                                          style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text(dataMatch["score2"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Text("Quart-temps 4"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(dataMatch["score1"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text("-",
                                          style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      Text(dataMatch["score2"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
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