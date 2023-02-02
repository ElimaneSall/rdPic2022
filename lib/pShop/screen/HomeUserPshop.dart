import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/pShop/model/xoss.dart';
import 'package:tuto_firebase/pShop/screen/Xossna.dart';
import 'package:tuto_firebase/pShop/widget/xossUser_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class HomeUserPshop extends StatefulWidget {
  const HomeUserPshop({Key? key}) : super(key: key);

  @override
  State<HomeUserPshop> createState() => _HomeUserPshopState();
}

class _HomeUserPshopState extends State<HomeUserPshop> {
  double sum = 0;
  void getSomme() {
    FirebaseFirestore.instance.collection('Xoss').get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if (result.data()["idUser"] ==
                  FirebaseAuth.instance.currentUser!.uid &&
              result.data()["statut"] == false) {
            sum = sum + result.data()['prix'];
          }
        });
        print("somme2$sum");
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    getSomme();
    print("somme1$sum");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference xoss = FirebaseFirestore.instance.collection('Xoss');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Polytech Shop",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeApp()));
          },
          child: Icon(Icons.home // add custom icons also
              ),
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          sum.toString() + " FCFA",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    "Samay Xoss",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: xoss
                          .orderBy("date", descending: true)
                          .where("idUser", whereIn: [
                        FirebaseAuth.instance.currentUser!.uid
                      ]).snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                      children:
                                          (snapshot.data! as QuerySnapshot)
                                              .docs
                                              .map((e) => XossUserCard(Xoss(
                                                  id: e.id,
                                                  date: e['date'],
                                                  prix: e['prix'],
                                                  idUser: e['idUser'],
                                                  produit: e['produits'],
                                                  statut: e["statut"])))
                                              .toList())),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 30.0,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Xossna()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
