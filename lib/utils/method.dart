import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

String timeAgoCustom(DateTime d) {
  // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "Il y'a " +
        "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "année" : "années"}";
  if (diff.inDays > 30)
    return "Il y'a " +
        "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "mois" : "mois"}";
  if (diff.inDays > 7)
    return "Il y'a " +
        "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "semaine" : "semaines"}";
  if (diff.inDays > 0)
    return "Il y'a " + "${diff.inDays} ${diff.inDays == 1 ? "jour" : "jours"}";
  //"${DateFormat.E().add_jm().format(d)}";
  if (diff.inHours > 0)
    return "Il y'a " +
        "${diff.inHours} ${diff.inHours == 1 ? "heure" : "heures"}";
  //return "Today ${DateFormat('jm').format(d)}";
  if (diff.inMinutes > 0)
    return "Il y'a " +
        "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}";
  return "Maintenant";
}

String dateCustomformat(DateTime d) {
  final newFormatter = DateFormat("EEEE dd MMMM yyyy, hh:mm:ss", "fr");
  final newFormatString = newFormatter.format(d);

  final result =
      newFormatString[0].toUpperCase() + newFormatString.substring(1);
  return result;
}

Future openDiallog(
        BuildContext context,
        TextEditingController controller,
        String id,
        String collection,
        String champ,
        String title,
        String hiintext,
        String childText) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hiintext),
        ),
        actions: [
          TextButton(
              onPressed: () {
                try {
                  FirebaseFirestore.instance
                      .collection(collection)
                      .doc(id)
                      .update({
                    champ: int.parse(controller.value.text),
                  }).then((value) => print("données à jour"));
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text("Modifier"))
        ],
      ),
    );

Future commentOpenDiallog(
  BuildContext context,
  TextEditingController controller,
  String id,
  String collection,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Commentaire"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Ecrire un commentaire"),
        ),
        actions: [
          TextButton(
              onPressed: () {
                try {
                  FirebaseFirestore.instance
                      .collection(collection)
                      .doc(id)
                      .update({
                    "commentaires": FieldValue.arrayUnion([
                      {
                        "idUser": FirebaseAuth.instance.currentUser!.uid,
                        "date": DateTime.now(),
                        "commentaire": controller.value.text
                      }
                    ]),
                  }).then((value) {
                    print("données à jour");
                    Navigator.pop(context);
                  });
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text("Commenter"))
        ],
      ),
    );

void addLikes(String docID, String collection, int likes) {
  var newLikes = likes + 1;
  try {
    FirebaseFirestore.instance.collection(collection).doc(docID).update({
      'likes': newLikes,
    }).then((value) => print("données à jour"));
  } catch (e) {
    print(e.toString());
  }
}

void deleteFunction(String docID, String collection) {
  try {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .delete()
        .then((value) => print("données à jour"));
  } catch (e) {
    print(e.toString());
  }
}

void undLike(String docID, String collection, int likes) {
  var newLikes = likes + 1;
  try {
    FirebaseFirestore.instance.collection(collection).doc(docID).update({
      'unlikes': newLikes,
    }).then((value) => print("données à jour"));
  } catch (e) {
    print(e.toString());
  }
}

Future openDialogDelete(
  BuildContext context,
  String id,
  String collection,
  String title,
  String contentMessage,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          child: Text(
            contentMessage,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                try {
                  FirebaseFirestore.instance
                      .collection(collection)
                      .doc(id)
                      .delete()
                      .then((value) =>
                          {print("données à jour"), Navigator.pop(context)});
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text("Supprimer"))
        ],
      ),
    );

Future OpenDialogBut(
  BuildContext context,
  TextEditingController controller,
  String id,
  String collection,
  String champ,
  int ancienValue,
) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Ajouter un but"),
              content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    rounderButton(
                        collection, id, champ, ancienValue, 1, context),
                    rounderButton(
                        collection, id, champ, ancienValue, 2, context),
                    rounderButton(
                        collection, id, champ, ancienValue, 3, context),
                    rounderButton(
                        collection, id, champ, ancienValue, -1, context),
                    rounderButton(
                        collection, id, champ, ancienValue, -2, context),
                    rounderButton(
                        collection, id, champ, ancienValue, -3, context),
                  ],
                ),
              ),
            ));

Color _colorIconPlus = Colors.black;
double _sizeIconPlus = 20;
Widget rounderButton(String collection, String id, String champ,
    int ancienValue, int step, BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      try {
        FirebaseFirestore.instance
            .collection(collection)
            .doc(id)
            .update({champ: ancienValue + step}).then((value) {
          print("données à jour");
          Navigator.pop(context);
        });
      } catch (e) {
        print(e.toString());
      }
    },
    child: Text('${step}'),
    style: ElevatedButton.styleFrom(
      shape: CircleBorder(),
      padding: EdgeInsets.all(10),
    ),
  );
}

void addToDatabase(
    String docID, int ancienNombre, String champ, String collection, int pas) {
  var newNombre = ancienNombre + pas;
  try {
    FirebaseFirestore.instance.collection(collection).doc(docID).update({
      '${champ}': newNombre,
    }).then((value) => print("données à jour"));
  } catch (e) {
    print(e.toString());
  }
}

ButtonAdd(_id, int ancienData, String fieldData, String collection, int pas) {
  return IconButton(
      onPressed: () {
        addToDatabase(_id, ancienData, fieldData, collection, pas);
      },
      icon: Icon(Icons.add),
      color: _colorIconPlus,
      iconSize: _sizeIconPlus);
}

ButtonBut(
    _id,
    int ancienData,
    String fieldData,
    BuildContext context,
    TextEditingController controller,
    String buteur,
    String collection,
    int pas) {
  return IconButton(
      onPressed: () {
        addToDatabase(_id, ancienData, fieldData, collection, pas);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Buteur"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Nom du buteur"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    try {
                      FirebaseFirestore.instance
                          .collection("Matchs")
                          .doc(_id)
                          .update({
                        buteur: FieldValue.arrayUnion([
                          {"buteur": controller.value.text}
                        ]),
                      }).then((value) {
                        print("données à jour");
                        Navigator.pop(context);
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Text("Modifier"))
            ],
          ),
        );
      },
      icon: Icon(Icons.add),
      color: _colorIconPlus,
      iconSize: _sizeIconPlus);
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

void addNotif(String title, String body, String idUser) {
  try {
    FirebaseFirestore.instance.collection("Notifs").add({
      "idUser": idUser,
      "time": DateTime.now(),
      "title": title,
      "body": body,
      "isActive": true
    });
  } catch (e) {
    print(e.toString());
  }
}

getUsersId() {
  List usersToken = [];
  List usersId = [];
  FirebaseFirestore.instance.collection('Users').get().then(
    (querySnapshot) {
      querySnapshot.docs.forEach((result) {
        usersToken.add(result.data()["token"]);
        usersId.add(result.id);
      });
      print("Liste 2 des user ID$usersId");
    },
  );
  return [usersId, usersToken];
}
