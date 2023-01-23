import 'package:cloud_firestore/cloud_firestore.dart';

class Matches {
  String id;
  String equipe1;
  String equipe2;
  int score1;
  Timestamp date;
  int score2;
  int likes;
  List commentaires;

  Matches({
    required this.likes,
    required this.commentaires,
    required this.id,
    required this.equipe1,
    required this.equipe2,
    required this.score1,
    required this.date,
    required this.score2,
    //required this.likes,
  });
}
