import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class RepondreMessage extends StatefulWidget {
  String id;
  RepondreMessage(this.id);

  @override
  State<RepondreMessage> createState() => _RepondreMessageState(id);
}

class _RepondreMessageState extends State<RepondreMessage> {
  String _id;
  final reponsecontroller = TextEditingController();
  _RepondreMessageState(this._id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text('Repondre'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.black)),
                title: Row(children: [
                  Text('Reponse'),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: reponsecontroller,
                  ))
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black26;
                        }
                        return AppColors.primary;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)))),
                  onPressed: () {
                    /*  FirebaseFirestore.instance
                        .collection('SOS')
                        .doc(_id)
                        .collection("Reponses")
                        .add({
                      "reponse": reponsecontroller.value.text,
                      "idAuteur": FirebaseAuth.instance.currentUser!.uid,
                      "date": DateTime.now()
                    });
                    */
                    FirebaseFirestore.instance
                        .collection('SOS')
                        .doc(_id)
                        .update({
                      'reponses': FieldValue.arrayUnion([
                        {
                          "idUser": FirebaseAuth.instance.currentUser!.uid,
                          "date": DateTime.now(),
                          "reponse": reponsecontroller.value.text
                        }
                      ]),
                    });

                    Navigator.pop(context);
                  },
                  child: Text('Repondre'))
            ])));
  }
}
