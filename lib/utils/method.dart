import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
