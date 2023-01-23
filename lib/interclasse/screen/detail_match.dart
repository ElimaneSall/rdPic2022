import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/screen/commentMatchPage.dart';
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

  void addLikes(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('Matchs').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

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
                        padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Image.asset("equipe1.png",
                                          width: 100, height: 40),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(dataMatch["idEquipe1"],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text("Cards",
                                          style: TextStyle(
                                            color: Colors.blue,
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
                                  Column(
                                    children: [
                                      Text("Full time"),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Text(dataMatch["score1"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text("-",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(dataMatch["score2"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Image.asset("ball_football.png",
                                          width: 100, height: 40),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Image.asset("equipe2.png",
                                          width: 100, height: 40),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(dataMatch["idEquipe2"],
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text("Cards",
                                          style: TextStyle(
                                            color: Colors.blue,
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
                                  Center(
                                      child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          height: 40,
                                          //  width: 290,

                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        addLikes(_id, 1);
                                                      },
                                                      icon:
                                                          Icon(Icons.favorite)),
                                                  // SizedBox(height: 10,),
                                                  Text(1.toString())
                                                ],
                                              ),
                                              SizedBox(
                                                width: 70,
                                              ),
                                              InkWell(
                                                  child: Text(
                                                    "Comment",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                  onTap: () {
                                                    commentOpenDiallog(
                                                        context,
                                                        controller,
                                                        _id,
                                                        "Matchs");
                                                  }),
                                              SizedBox(
                                                width: 70,
                                              ),
                                              InkWell(
                                                  child: Text(
                                                    "Share",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                  onTap: () {
                                                    // Navigator.push(context,
                                                    // MaterialPageRoute(builder: (context) => LirePDF( ) ));
                                                  })
                                            ],
                                          ))),
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
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage: NetworkImage(
                                                        "https://st.depositphotos.com/1011643/2013/i/950/depositphotos_20131045-stock-photo-happy-male-african-university-student.jpg"),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Elimane Sall",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      //   Text(
                                                      //       "Il y'a ${(DateTime.now().toIso8601String())} heures")
                                                    ],
                                                  )
                                                ],
                                              ),
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
