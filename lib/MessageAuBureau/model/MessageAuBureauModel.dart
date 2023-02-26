import 'package:cloud_firestore/cloud_firestore.dart';

class MessageAuBureauModel {
  String id;
  String message;
  List reponses;
  Timestamp date;

  MessageAuBureauModel(
      {required this.id,
      required this.message,
      required this.reponses,
      required this.date});
}
