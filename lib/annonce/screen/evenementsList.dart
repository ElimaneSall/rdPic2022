import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/evenement.dart';
import 'package:tuto_firebase/annonce/sideBar/sideBar.dart';
import 'package:tuto_firebase/annonce/widget/evenementCard.dart';

class EvenementList extends StatefulWidget {
  const EvenementList({Key? key}) : super(key: key);

  @override
  State<EvenementList> createState() => _EvenementListState();
}

class _EvenementListState extends State<EvenementList> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection('Evenement');
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Evenement")),
          backgroundColor: Colors.blue,
        ),
        drawer: NavBar(),
        //backgroundColor: Colors.blue,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Liste des evenements récents",
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
                      products.orderBy('date', descending: false).snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: (snapshot.data! as QuerySnapshot)
                              .docs
                              .map((e) => EvenementCard(Evenement(
                                    commentaires: e['commentaires'],
                                    likes: e['likes'],
                                    image: e['image'],
                                    titre: e['titre'],
                                    poste: e['poste'],
                                    date: e['date'],
                                    status: e['status'],
                                    // description: e['description'],
                                    auteur: e['auteur'],
                                    id: e.id,
                                    // likes: e['likes']
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
