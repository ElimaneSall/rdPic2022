import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Xoss {
  String id;
  // String idd;
  String idUser;
  Timestamp date;
  int prix;
  List produit;
  bool statut;

  Xoss(
      {required this.id,
      required this.date,
      required this.idUser,
      required this.prix,
      required this.produit,
      required this.statut});
}
