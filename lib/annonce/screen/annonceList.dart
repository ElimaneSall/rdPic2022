import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';
import 'package:tuto_firebase/annonce/sideBar/sideBar.dart';
import 'package:tuto_firebase/annonce/widget/annonceCard.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class AnnonceList extends StatefulWidget {
  const AnnonceList({Key? key}) : super(key: key);

  @override
  State<AnnonceList> createState() => _AnnonceListState();
}

class _AnnonceListState extends State<AnnonceList> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection('Annonce');
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Annonce")),
          backgroundColor: AppColors.primary,
        ),
        drawer: NavBar(role),
        //backgroundColor: Colors.blue,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Column(
            children: [
              Text(
                "Liste des annonces récentes",
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
                      products.orderBy('date', descending: true).snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: (snapshot.data! as QuerySnapshot)
                              .docs
                              .map((e) => AnnonceCard(
                                  Annonce(
                                    id: e.id,
                                    idUser: e["idUser"],
                                    likes: e['likes'],
                                    unlikes: e['unlikes'],
                                    commentaires: e['commentaires'],
                                    titre: e['titre'],
                                    poste: e['poste'],
                                    date: e['date'],
                                    status: e['status'],
                                    // description: e['description'],
                                    urlFile: e['urlFile'],
                                    annonce: e['annonce'],
                                    // likes: e['likes']
                                  ),
                                  Container(
                                    child: Text("Download"),
                                  )))
                              .toList());
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
