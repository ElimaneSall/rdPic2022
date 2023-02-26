import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/handball/screen/DetailMatchHandballEnCours.dart';
import 'package:tuto_firebase/services/notification.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailMatchGenieEnHerbeEnCours extends StatefulWidget {
  String id;

  DetailMatchGenieEnHerbeEnCours(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailMatchGenieEnHerbeEnCours> createState() =>
      _DetailMatchGenieEnHerbeEnCoursState(
        id,
      );
}

class _DetailMatchGenieEnHerbeEnCoursState
    extends State<DetailMatchGenieEnHerbeEnCours> {
  String _id;

  _DetailMatchGenieEnHerbeEnCoursState(
    this._id,
  );
  TextEditingController controller = TextEditingController();
  final Stream<QuerySnapshot> _articleStream =
      FirebaseFirestore.instance.collection('GenieEnHerbe').snapshots();
  List userTokens = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userTokens = getUsersId()[1];
    // _match = FirebaseFirestore.instance.collection('GenieEnHerbe').doc(_id);
  }

  List<String> _rubirque = [
    'Rubrique 1',
    "Rubrique 2",
    'Rubrique 3',
    'Rubrique 4',
    "Rubrique 5"
  ];
  String? selectedRubrique = "Rubrique 1";
  TextEditingController scorecontroller1 = TextEditingController();
  TextEditingController scorecontroller2 = TextEditingController();
  TextEditingController nomButeurController = TextEditingController();
  TextEditingController nomButeurController2 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DocumentReference _match =
        FirebaseFirestore.instance.collection('GenieEnHerbe').doc(_id);
    return FutureBuilder<DocumentSnapshot>(
        future: _match!.get(),
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
                        child: Text("Détail du match de Génie En Herbe")),
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
                                  GestureDetector(
                                    child: Icon(Icons.add),
                                    onTap: () {
                                      OpenDialogBut(
                                          context,
                                          controller,
                                          _id,
                                          "GenieEnHerbe",
                                          "score1",
                                          dataMatch["score1"]);
                                      // initState();
                                      // setState(() {
                                      //   _match = FirebaseFirestore.instance
                                      //       .collection('GenieEnHerbe')
                                      //       .doc(_id);
                                      // });
                                    },
                                  ),
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
                                    onTap: () => OpenDialogBut(
                                        context,
                                        controller,
                                        _id,
                                        "GenieEnHerbe",
                                        "score2",
                                        dataMatch["score2"]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (var set in dataMatch["rubriques"])
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(set["nomRubrique"]),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                set["scoreRubrique1"]
                                                    .toString(),
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
                                            Text(
                                                set["scoreRubrique2"]
                                                    .toString(),
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
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("Fin Rubrique"),
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
                                                    Text('Rubrique: '),
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child: DropdownButton(
                                                          value:
                                                              selectedRubrique,
                                                          items: _rubirque
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
                                                                  selectedRubrique =
                                                                      item
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
                                                          .collection(
                                                              "GenieEnHerbe")
                                                          .doc(_id)
                                                          .update({
                                                        "rubriques": FieldValue
                                                            .arrayUnion([
                                                          {
                                                            "scoreRubrique1":
                                                                int.parse(
                                                                    scorecontroller1
                                                                        .value
                                                                        .text),
                                                            "scoreRubrique2":
                                                                int.parse(
                                                                    scorecontroller2
                                                                        .value
                                                                        .text),
                                                            "nomRubrique":
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
                                                  child: Text("Fin rubrique"))
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text("Fin rubrique"))),
                              Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        MeilleurButteurDialog(
                                            context,
                                            controller,
                                            nomButeurController,
                                            controller2,
                                            nomButeurController2,
                                            _id,
                                            "GenieEnHerbe");
                                      },
                                      child: Text("Fin du Match"))),
                            ]))));
          }
          return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title:
                      Center(child: Text("Détail du match de Génie En Herbe")),
                  backgroundColor: AppColors.primary),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        });
  }
}
