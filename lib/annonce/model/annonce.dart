import 'package:cloud_firestore/cloud_firestore.dart';

class Annonce {
  String id;
  String titre;
  // String image;
  String auteur;
  Timestamp date;
  String poste;
  String status;
  String annonce;
  int likes;
  List commentaires;

  Annonce({
    required this.id,
    required this.titre,
    required this.auteur,
    required this.date,
    required this.poste,
    required this.status,
    required this.annonce,
    required this.likes,
    required this.commentaires,
  });
}
