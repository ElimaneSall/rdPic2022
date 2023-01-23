

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/model/menu.dart';
import 'package:tuto_firebase/widget/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore
    .collection('Product');
    return  Scaffold(
     // backgroundColor: Colors.yellow,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 32,
             horizontal: 20),
             child: Column(
              children: [
                Text("Liste des produits récents",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:FontWeight.w500,
                  color: Colors.black
                ),),
          SizedBox(height: 22,),

      StreamBuilder<QuerySnapshot>(
        stream: products.orderBy('id', descending: false).snapshots(),
        builder: (_,snapshot){
          if(snapshot.hasData){
            return  Column(
          children: (snapshot.data! as QuerySnapshot)
          .docs.
          map(
            (e) =>MenuCard(
            Menu(
              id:e['id'],
              image: e['image'],
              name: e['name'],
             // price: e['price'],
              // pricepromo: e['pricePromo'],
               isPromo: e['isPromo'], 
               note: e['note']
               ))
               ).toList()
          );
          }else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
      )
             ],),
             )
             ),
    );
  }
}