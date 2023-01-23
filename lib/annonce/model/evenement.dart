import 'package:cloud_firestore/cloud_firestore.dart';

class Evenement {
  String titre;
  String image;
  String auteur;
  Timestamp date;
  String poste;
  String status;
  String id;
  List commentaires;
  // String description;
  int likes;

  Evenement(
      {
      // required this.id,
      required this.image,
      required this.commentaires,
      required this.titre,
      required this.auteur,
      required this.date,
      required this.poste,
      required this.status,
      required this.id,
      required this.likes});
}
