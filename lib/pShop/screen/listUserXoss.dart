import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/pShop/model/xoss.dart';
import 'package:tuto_firebase/pShop/widget/ListXossUsers_card.dart';
import 'package:tuto_firebase/pShop/widget/xossUser_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class ListUserXoss extends StatefulWidget {
  const ListUserXoss({Key? key}) : super(key: key);

  @override
  State<ListUserXoss> createState() => _ListUserXossState();
}

class _ListUserXossState extends State<ListUserXoss> {
  @override
  final Stream<QuerySnapshot> xoss =
      FirebaseFirestore.instance.collection('Xoss').snapshots();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Liste des clients"),
          centerTitle: true,
        ),
        body: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Center(
                heightFactor: 10,
                widthFactor: 100,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        // height: MediaQuery.of(context).size.height * 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: xoss,
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("Loading");
                                  }

                                  if (snapshot.hasData) {
                                    return Column(children: [
                                      Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 30, 10, 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                              children: (snapshot.data!
                                                      as QuerySnapshot)
                                                  .docs
                                                  .map((e) => ListXossUsers(
                                                      Xoss(
                                                          id: e.id,
                                                          date: e['date'],
                                                          prix: e['prix'],
                                                          idUser: e['idUser'],
                                                          produit:
                                                              e['produits'],
                                                          statut: e["statut"])))
                                                  .toList()))
                                    ]);
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),
                          ],
                        ))))));
  }
}
