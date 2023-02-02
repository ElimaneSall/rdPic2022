import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailMatchTennisEnCours extends StatefulWidget {
  String id;

  DetailMatchTennisEnCours(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailMatchTennisEnCours> createState() =>
      _DetailMatchTennisEnCoursState(
        id,
      );
}

class _DetailMatchTennisEnCoursState extends State<DetailMatchTennisEnCours> {
  String _id;

  _DetailMatchTennisEnCoursState(
    this._id,
  );
  TextEditingController controller = TextEditingController();
  TextEditingController scorecontroller1 = TextEditingController();
  TextEditingController scorecontroller2 = TextEditingController();
  final Stream<QuerySnapshot> _articleStream =
      FirebaseFirestore.instance.collection('Tennis').snapshots();
  List<String> _set = ['Set 1', "Set 2", 'Set 3', 'Set 4'];
  String? selectedSet = "Set 1";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Tennis').doc(_id).get(),
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
                    title: Center(child: Text("Détail du match tennis")),
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
                                      "Tennis", 1),
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
                                      "Tennis", 1),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      dataMatch["meilleurbuteurs1"]["nom"]
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                  Text(
                                      "(${dataMatch["meilleurbuteurs1"]["points"].toString()})",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("-",
                                      style: TextStyle(
                                          color: AppColors.blue,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                      dataMatch["meilleurbuteurs2"]["nom"]
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                  Text(
                                      "(${dataMatch["meilleurbuteurs2"]["points"].toString()})",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
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
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Fin d'un set"),
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
                                                    Text('Set: '),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: DropdownButton(
                                                          value: selectedSet,
                                                          items: _set
                                                              .map((item) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                    child: Text(
                                                                        item),
                                                                    value: item,
                                                                  ))
                                                              .toList(),
                                                          onChanged: (item) =>
                                                              setState(() =>
                                                                  selectedSet = item
                                                                      as String),
                                                        ))
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
                                                          .collection("Tennis")
                                                          .doc(_id)
                                                          .update({
                                                        "sets": FieldValue
                                                            .arrayUnion([
                                                          {
                                                            "scoreSet1": int.parse(
                                                                scorecontroller1
                                                                    .value
                                                                    .text),
                                                            "scoreSet2": int.parse(
                                                                scorecontroller2
                                                                    .value
                                                                    .text),
                                                            "nomSet":
                                                                selectedSet
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
                                                  child: Text("Fin d'un set"))
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text("Fin d'un set"))),
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
                                                addLikes(_id, "Tennis",
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
                                                undLike(_id, "Tennis",
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
                                                    controller, _id, "Tennis");
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

// Future<dynamic> MeilleurButteurDialog(
//   BuildContext context,
//   TextEditingController nomButeurcontroller1,
//   TextEditingController nombreButController1,
//   TextEditingController nomButeurcontroller2,
//   TextEditingController nombreButController2,
//   String id,
//   String collection,
// ) {
//   List<String> phase = ['Set 1', "Set 2", 'Set 3', 'Set 4'];
//   String? selectedPhase = "Set 1";
//   return showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text("Meilleur buteur"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4),
//                 side: BorderSide(color: Colors.white)),
//             title: Row(children: [
//               Text('Set'),
//               SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.5,
//                   child: DropdownButton(
//                     value: selectedPhase,
//                     items: phase
//                         .map((item) => DropdownMenuItem<String>(
//                               child: Text(item),
//                               value: item,
//                             ))
//                         .toList(),
//                     onChanged: (item) =>
//                         setState(() => selectedPhase = item as String?),
//                   ))
//             ]),
//           ),
//           TextField(
//             controller: nomButeurcontroller1,
//             decoration:
//                 InputDecoration(hintText: "Nom du buteur de l'équipe 1"),
//           ),
//           TextField(
//             controller: nombreButController1,
//             decoration:
//                 InputDecoration(hintText: "Nombre de but de l'équipe 1"),
//           ),
//           TextField(
//             controller: nomButeurcontroller2,
//             decoration:
//                 InputDecoration(hintText: "Nom du buteur de l'équipe 2"),
//           ),
//           TextField(
//             controller: nombreButController2,
//             decoration:
//                 InputDecoration(hintText: "Nombre de but de l'équipe 2"),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//             onPressed: () {
//               try {
//                 FirebaseFirestore.instance
//                     .collection(collection)
//                     .doc(id)
//                     .update({
//                   "meilleurbuteurs1.nom": nomButeurcontroller1.value.text,
//                   "meilleurbuteurs1.points":
//                       int.parse(nombreButController1.value.text),
//                   "meilleurbuteurs2.nom": nomButeurcontroller2.value.text,
//                   "meilleurbuteurs2.points":
//                       int.parse(nombreButController2.value.text)
//                 }).then((value) {
//                   print("données à jour");
//                   Navigator.pop(context);
//                 });
//               } catch (e) {
//                 print(e.toString());
//               }
//             },
//             child: Text("Fin du match"))
//       ],
//     ),
//   );
// }
