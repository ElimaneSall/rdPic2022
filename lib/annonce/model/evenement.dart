import 'package:cloud_firestore/cloud_firestore.dart';

class Evenement {
  String titre;
  String image;

  Timestamp date;
  String poste;
  String status;
  String id;
  String idUser;
  List commentaires;
  String description;
  String auteur;
  int likes;

  Evenement(
      {
      // required this.id,
      required this.image,
      required this.commentaires,
      required this.titre,
      required this.date,
      required this.poste,
      required this.status,
      required this.id,
      required this.idUser,
      required this.likes,
      required this.auteur,
      required this.description});
}
