import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/handball/screen/DetailMatchHandballEnCours.dart';
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

  TextEditingController nomButeurController = TextEditingController();
  TextEditingController nomButeurController2 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  List<String> _set = [
    'Premier set',
    "Deuxième set",
    'Troisième set',
    'Quatrième set',
    "Cinquième set"
  ];
  String? selectedSet = "Premier set";

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
                                            "Volley");
                                      },
                                      child: Text("Fin du Match"))),
                            ]))));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
