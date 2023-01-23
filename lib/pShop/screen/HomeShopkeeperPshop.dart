import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/blog/sidebar/nav_drawer.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/pShop/model/xoss.dart';
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
  int somme = 0;
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
      ),
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
                              Text("Total " + somme.toString()),
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
