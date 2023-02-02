import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/blog/sidebar/nav_drawer.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/notifications/notifications_page.dart';
import 'package:tuto_firebase/pShop/model/xoss.dart';
import 'package:tuto_firebase/pShop/screen/AllXossUser.dart';
import 'package:tuto_firebase/pShop/screen/Xossna.dart';
import 'package:tuto_firebase/pShop/screen/listUserXoss.dart';
import 'package:tuto_firebase/pShop/widget/xossShopKeeper_card.dart';
import 'package:tuto_firebase/pShop/widget/xossUser_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class HomeShopkeeperPshop extends StatefulWidget {
  const HomeShopkeeperPshop({Key? key}) : super(key: key);

  @override
  State<HomeShopkeeperPshop> createState() => _HomeShopkeeperPshopState();
}

class _HomeShopkeeperPshopState extends State<HomeShopkeeperPshop> {
  double somme = 0;
  void getSomme() {
    FirebaseFirestore.instance.collection('Xoss').get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if (result.data()["statut"] == false) {
            somme = somme + result.data()['prix'];
          }
        });
        print("somme2$somme");
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    somme = 0;
    getSomme();
    print("somme1$somme");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference xoss = firestore.collection('Xoss');
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Polytech Shop"),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListUserXoss()));
            },
            child: Icon(Icons.group // add custom icons also
                ),
          ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    initState();
                  },
                  child: Icon(Icons.refresh // add custom icons also
                      ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notifications()));
                  },
                  child: Icon(Icons.notification_add // add custom icons also
                      ),
                ),
              ],
            )
          ]),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Xoss yi",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(139, 137, 129, 1),
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream:
                          xoss.orderBy('date', descending: false).snapshots(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      somme.toString() + " FCFA",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04),
                                    ),
                                  )),
                              Container(
                                  padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                      children:
                                          (snapshot.data! as QuerySnapshot)
                                              .docs
                                              .map((e) => xossShopKeeper(Xoss(
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
      /*floatingActionButton: FloatingActionButton(
        elevation: 30.0,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Xossna()),
          );
        },
      ),*/
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
