import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class TestNotification2 extends StatefulWidget {
  const TestNotification2({super.key});

  @override
  State<TestNotification2> createState() => _TestNotification2State();
}

class _TestNotification2State extends State<TestNotification2> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  String? mtoken = "";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();

    _requestPermission();
    getToken();
    initInfo();
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Authorization":
                "key=AAAAVIafLa0:APA91bEHCxiZ0-FI8AfGSxwYiPZDOd30TNgRlLXA9hhqmf8dglueUuAuTigHbAUkGl7hZXWEWMCUmreF59ITkQsDRpMonsgAcCAVE43ipc1onphXPCSU25j2tBKRl9zT2U0bqLMBS1Ye"
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood"
            },
            "to": token
          }));
    } catch (e) {}
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

  void _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserToken").doc("User3").set({
      "token": token,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: Column(children: [
          TextFormField(
            controller: username,
          ),
          TextFormField(
            controller: title,
          ),
          TextFormField(
            controller: body,
          ),
          ElevatedButton(
              onPressed: () async {
                String name = username.value.text;
                String titleText = title.value.text;
                String bodyText = body.value.text;
                print("MyName $name");
                if (name != "") {
                  DocumentSnapshot documentSnapshot = await FirebaseFirestore
                      .instance
                      .collection("UserToken")
                      .doc(name)
                      .get();
                  String token = documentSnapshot["token"];
                  print("Token in BD$token");

                  sendPushMessage(token, titleText, bodyText);
                }
              },
              child: Text("Send notification"))
        ]),
      ),
    );
  }
}
