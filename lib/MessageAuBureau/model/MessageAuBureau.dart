import 'package:cloud_firestore/cloud_firestore.dart';

class MessageAuBureau {
  String id;
  String idAuteur;
  String message;

  List reponse;
  Timestamp date;

  MessageAuBureau(
      {required this.id,
      required this.date,
      required this.message,
      required this.idAuteur,
      required this.reponse});
}
