import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/screen/adminFootball.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';

class CreateMatch extends StatefulWidget {
  const CreateMatch({Key? key}) : super(key: key);

  @override
  State<CreateMatch> createState() => _CreateMatchState();
}

class _CreateMatchState extends State<CreateMatch> {
  TextEditingController _equipeTextController = TextEditingController();
  TextEditingController _adversaireTextController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Créer un match"),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Equipe 1", Icons.add, false,
                        _equipeTextController, Colors.blue),
                    SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Equipe 2", Icons.add, false,
                        _adversaireTextController, Colors.blue),
                    SizedBox(
                      height: 20,
                    ),
                    InputDatePickerFormField(
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                      initialDate: selectedDate,
                      onDateSubmitted: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text('Select date'),
                    ),
                    signInSignUpButton("Créer", context, false, () {
                      FirebaseFirestore.instance.collection('Matchs').add({
                        "idEquipe1": _equipeTextController.value.text,
                        "idEquipe2": _adversaireTextController.value.text,
                        "redCard1": 0,
                        "redCard2": 0,
                        "yellowCard1": 0,
                        "yellowCard2": 0,
                        "corners1": 0,
                        "corners2": 0,
                        "fautes1": 0,
                        "fautes2": 0,
                        "score1": 0,
                        "score2": 0,
                        "tirs1": 0,
                        "tirs2": 0,
                        "tirsCadres1": 0,
                        "tirsCadres2": 0,
                        "date": selectedDate,
                        "dateCreation": DateTime.now(),
                        "commentaires": [],
                        "likes": 0
                      });
                      /* String id_match = "";
                      FirebaseFirestore.instance
                          .collection("Matchs")
                          .limit(1)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          id_match = doc.id;
                          print("datebi" + doc["date"].toString());
                        });
                      });
                      print("idbi" + id_match);

                      FirebaseFirestore.instance
                          .collection('Equipes')
                          .doc(_equipeTextController.value.text)
                          .update({
                        'match': FieldValue.arrayUnion([id_match]),
                      });

                      FirebaseFirestore.instance
                          .collection('Equipes')
                          .doc(_adversaireTextController.value.text)
                          .update({
                        'match': FieldValue.arrayUnion([id_match]),
                      });
                      */
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminFootball()));
                    }),
                  ])))),
    );
  }
}
