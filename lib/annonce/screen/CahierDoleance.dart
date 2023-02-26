import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/MessageAuBureau/model/MessageAuBureauModel.dart';
import 'package:tuto_firebase/MessageAuBureau/widget/MessageAuBureauCard.dart';

import '../../MessageAuBureau/widget/DetailMessage.dart';
import '../../utils/color/color.dart';
import '../../utils/method.dart';
import '../sideBar/sideBar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CahierDoleance extends StatefulWidget {
  const CahierDoleance({super.key});

  @override
  State<CahierDoleance> createState() => _CahierDoleanceState();
}

class _CahierDoleanceState extends State<CahierDoleance> {
  String role = "user";
  getRole() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        role = documentSnapshot.get("role");
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference evenements = firestore.collection('MessageAuBureau');
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Cahier des doléances")),
          backgroundColor: AppColors.primary,
        ),
        drawer: NavBar(role),
        //backgroundColor: Colors.blue,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Text(
                "Liste des doléances récents",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 22,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream:
                      evenements.orderBy('date', descending: true).snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                          // color: AppColors.background,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: (snapshot.data! as QuerySnapshot)
                                  .docs
                                  .map((e) {
                                return MessageAuBureauCard(MessageAuBureauModel(
                                    id: e.id,
                                    message: e["message"],
                                    reponses: e["reponses"],
                                    date: e["date"]));
                              }).toList()));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ))));
  }
}
