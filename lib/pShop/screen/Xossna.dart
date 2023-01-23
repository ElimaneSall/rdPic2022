import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/pShop/screen/SuccessMessage.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import '../../widget/reusableTextField.dart';

class Xossna extends StatefulWidget {
  const Xossna({Key? key}) : super(key: key);

  @override
  State<Xossna> createState() => _XossnaState();
}

class _XossnaState extends State<Xossna> {
  TextEditingController _produitTextController = TextEditingController();
  TextEditingController _prixTextController = TextEditingController();
  List listProduit = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Xossna")),
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
                      reusableTextField("Produit", Icons.add, false,
                          _produitTextController, Colors.blue),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Prix", Icons.add, false,
                          _prixTextController, Colors.blue),
                      signInSignUpButton("Xossna", context, false, () {
                        listProduit =
                            _produitTextController.value.text.split(";");
                        FirebaseFirestore.instance.collection('Xoss').add({
                          'produits': FieldValue.arrayUnion(listProduit),
                          "prix": int.parse(_prixTextController.value.text),
                          "date": DateTime.now(),
                          "idUser": FirebaseAuth.instance.currentUser!.uid,
                          "statut": false
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SuccessMessage()));
                      }),
                    ])))));
  }
}
