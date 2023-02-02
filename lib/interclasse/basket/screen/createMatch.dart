import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/interclasse/screen/adminFootball.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';

class CreateBasketMatch extends StatefulWidget {
  const CreateBasketMatch({Key? key}) : super(key: key);

  @override
  State<CreateBasketMatch> createState() => _CreateBasketMatchState();
}

class _CreateBasketMatchState extends State<CreateBasketMatch> {
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
                        FirebaseFirestore.instance.collection('Basket').add({
                          "idEquipe1": _equipeTextController.value.text,
                          "idEquipe2": _adversaireTextController.value.text,
                          "fautesIndiv1": 0,
                          "fautesIndiv2": 0,
                          "fautes1": 0,
                          "fautes2": 0,
                          "score1": 0,
                          "score2": 0,
                          "rebond1": 0,
                          "rebond2": 0,
                          "meilleurbuteurs1": {},
                          "meilleurbuteurs2": {},
                          "Meilleurbuteurs": "",
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
