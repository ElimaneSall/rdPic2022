import 'package:cloud_firestore/cloud_firestore.dart';

class SOSModel {
  String id;
  String idAuteur;
  String sos;

  List reponse;
  Timestamp date;

  SOSModel(
      {required this.id,
      required this.date,
      required this.sos,
      required this.idAuteur,
      required this.reponse});
}
