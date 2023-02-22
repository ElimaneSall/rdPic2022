import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String id;
  String idUser;
  Timestamp date;
  List commentaires;
  String urlFile;
  String tweet;
  int likes;

  Tweet({
    required this.idUser,
    required this.date,
    required this.commentaires,
    required this.urlFile,
    required this.tweet,
    required this.likes,
    required this.id,
  });
}
