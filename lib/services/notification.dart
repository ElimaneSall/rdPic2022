import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

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

void saveToken(String token) async {
  await FirebaseFirestore.instance
      .collection("UserToken")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
    "token": token,
  });
}

String? mtoken;
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
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print("User granted provisional permission");
  } else {
    print("User declined or has not accepted permission");
  }
}

// void getToken() async {
//   await FirebaseMessaging.instance.getToken().then((token) {
//     // setState(() {
//     //   mtoken = token;
//     //   print("My token is $mtoken");
//     // });
//     saveToken(token!);
//   });
// }

// @override
// void initState() {
//   // TODO: implement initState
//   // super.initState();
//   getToken();
//   _requestPermission();
// }
