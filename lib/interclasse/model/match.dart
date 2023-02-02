import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Matches {
  String id;
  String idUser;
  String equipe1;
  String equipe2;
  int score1;
  Timestamp date;

  int score2;
  int likes;
  String phase;
  List commentaires;
  dynamic buteurs1;
  dynamic buteurs2;
  Matches(
      {required this.likes,
      required this.commentaires,
      required this.id,
      required this.idUser,
      required this.equipe1,
      required this.equipe2,
      required this.score1,
      required this.date,
      required this.score2,
      required this.phase,
      required this.buteurs1,
      required this.buteurs2
      //required this.likes,
      });
}
