import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/football/screen/adminFootball.dart';
import 'package:tuto_firebase/interclasse/tennis/screen/adminTennis.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';

class CreateTennisMatch extends StatefulWidget {
  CreateTennisMatch({Key? key}) : super(key: key);

  @override
  State<CreateTennisMatch> createState() => _CreateTennisMatchState();
}

class _CreateTennisMatchState extends State<CreateTennisMatch> {
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

  List<String> phase = ['Phase de poule', "Quart-Final", 'Demi-Final', 'Final'];
  String? selectedPhase = "Phase de poule";
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
        title: Text("Créer un match de tennis"),
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
                    ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: Colors.white)),
                      title: Row(children: [
                        Text('Phase'),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: DropdownButton(
                              value: selectedPhase,
                              items: phase
                                  .map((item) => DropdownMenuItem<String>(
                                        child: Text(item),
                                        value: item,
                                      ))
                                  .toList(),
                              onChanged: (item) => setState(
                                  () => selectedPhase = item as String?),
                            ))
                      ]),
                    ),
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
                      if (_equipeTextController.value.text !=
                          _adversaireTextController.value.text) {
                        FirebaseFirestore.instance.collection('Tennis').add({
                          "idEquipe1": _equipeTextController.value.text,
                          "idEquipe2": _adversaireTextController.value.text,
                          "score1": 0,
                          "score2": 0,
                          "sets": [],
                          "meilleurbuteurs1": {"nom": "", "points": 0},
                          "meilleurbuteurs2": {"nom": "", "points": 0},
                          "phase": selectedPhase,
                          "idUser": FirebaseAuth.instance.currentUser!.uid,
                          "date": selectedDate,
                          "dateCreation": DateTime.now(),
                          "commentaires": [],
                          "likes": 0,
                          "unlikes": 0
                        });
                      } else
                        (showAboutDialog(context: context));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => adminTennis()));
                    }),
                  ])))),
    );
  }
}
