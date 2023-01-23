import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/screen/SuccessMessageSOS.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import '../../pShop/screen/SuccessMessage.dart';
import '../../widget/reusableTextField.dart';

class LancerSOS extends StatefulWidget {
  const LancerSOS({Key? key}) : super(key: key);

  @override
  State<LancerSOS> createState() => _LancerSOSState();
}

class _LancerSOSState extends State<LancerSOS> {
  TextEditingController _sosTextController = TextEditingController();
  TextEditingController _sosGroupTextController = TextEditingController();
  List<String> group = ['tout', '50', '49', '48', '47', '46'];
  String? selectedGroup = "tout";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Lancer un SOS")),
          backgroundColor: AppColors.primary,
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
                      reusableTextField("Ecris ton SOS", Icons.edit_sharp,
                          false, _sosTextController, Colors.blue),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black)),
                        title: Row(children: [
                          Icon(
                            Icons.group,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text('Categorie groupe:'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: DropdownButton(
                                value: selectedGroup,
                                items: group
                                    .map((item) => DropdownMenuItem<String>(
                                          child: Text(item),
                                          value: item,
                                        ))
                                    .toList(),
                                onChanged: (item) => setState(
                                    () => selectedGroup = item as String?),
                              ))
                        ]),
                      ),
                      signInSignUpButton("Lancer le SOS", context, false, () {
                        CollectionReference sosRef =
                            FirebaseFirestore.instance.collection('SOS');
                        FirebaseFirestore.instance.collection('SOS').add({
                          'sos': _sosTextController.value.text,
                          'groupe': selectedGroup,
                          "date": DateTime.now(),
                          "reponses": [],
                          "idAuteur": FirebaseAuth.instance.currentUser!.uid,
                          "likes": 0,
                        });
                        sosRef
                            .doc("UCNWdGhmLsuZ6aYDimgb")
                            .collection("Reponses")
                            .add({});
                        sosRef.doc("UCNWdGhmLsuZ6aYDimgb").update({"nom": "i"});

                        /* FirebaseFirestore.instance
                            .collection('SOS')
                            .doc("bFPveFLPDTtfNk3EoUGS")
                            .collection("Reponses")
                            .add({});
                            */
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SuccessMessageSOS()));
                      }),
                    ])))));
  }
}
