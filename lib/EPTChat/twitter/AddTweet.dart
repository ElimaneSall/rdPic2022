import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuto_firebase/services/notification.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import '../../widget/reusableTextField.dart';

class AddTweet extends StatefulWidget {
  const AddTweet({super.key});

  @override
  State<AddTweet> createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  final titrecontroller = TextEditingController();
  final annoncecontroller = TextEditingController();
  final auteurcontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final postecontroller = TextEditingController();
  final statuscontroller = TextEditingController();

  List userId = [];
  List userToken = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void getUserId() {
    FirebaseFirestore.instance.collection('Users').get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          userToken.add(result.data()["token"]);
          userId.add(result.id);
        });
        print("Liste 2 des user ID$userId");
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    print("Liste des ID$userId");
    initInfo();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var IOSInitialize = IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: IOSInitialize);

    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onSelectNotification: (String? payload) async {
        try {
          if (payload != null && payload.isNotEmpty) {
          } else {}
        } catch (e) {
          print(e.toString());
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("----------------------onMessage-------------------");
      print(
          "onMessage:${message.notification!.title}/${message.notification!.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("dbfood", "dbfood",
              importance: Importance.max,
              styleInformation: bigTextStyleInformation,
              priority: Priority.max,
              playSound: true);
      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: message.data["title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text('Poster un tweet'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Tweet", Icons.edit_sharp, false,
                      annoncecontroller, Colors.blue),
                  SizedBox(
                    height: 10,
                  ),
                  signInSignUpButton("Poster", context, false, () {
                    try {
                      FirebaseFirestore.instance.collection('Tweet').add({
                        "idUser": FirebaseAuth.instance.currentUser!.uid,
                        "commentaires": [],
                        "date": DateTime.now(),
                        "likes": 0,
                        "tweet": annoncecontroller.value.text,
                        "urlFile": ""
                        // "commentaires": FieldValue.arrayUnion([
                        //   {
                        //     "idUser": FirebaseAuth.instance.currentUser!.uid,
                        //     "date": DateTime.now(),
                        //     "type": "Texte",
                        //     'status': annoncecontroller.value.text,
                        //     "urlFile": ""
                        //   }
                        // ]),
                      });
                      var i = 0;
                      for (var e in userToken) {
                        sendPushMessage(e!, " ${annoncecontroller.value.text} ",
                            "Tweet: ${titrecontroller.value.text} ");
                        addNotif(titrecontroller.value.text,
                            annoncecontroller.value.text, userId[i]);
                        i++;
                      }
                      i = 0;
                      Navigator.pop(context);
                    } catch (e) {
                      print(e.toString());
                    }
                  })
                ]))));
  }
}
