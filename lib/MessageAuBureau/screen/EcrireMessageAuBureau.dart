import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuto_firebase/SOSEPT/screen/SuccessMessageSOS.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import '../../pShop/screen/SuccessMessage.dart';
import '../../services/notification.dart';
import '../../utils/method.dart';
import '../../widget/reusableTextField.dart';

class EcrireMessageAuBureau extends StatefulWidget {
  const EcrireMessageAuBureau({Key? key}) : super(key: key);

  @override
  State<EcrireMessageAuBureau> createState() => _EcrireMessageAuBureauState();
}

class _EcrireMessageAuBureauState extends State<EcrireMessageAuBureau> {
  TextEditingController _messageTextController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List usersToken = [];

  List usersId = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      usersId = getUsersId()[0];
      usersToken = getUsersId()[1];
    });
    initInfo();
  }

  @override
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
          title: Center(
              child: Text("Ecrire un message au bureau de facon anonyme")),
          backgroundColor: AppColors.primary,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Ecris ton message", Icons.edit_sharp,
                          false, _messageTextController, Colors.blue),
                      SizedBox(
                        height: 20,
                      ),
                      signInSignUpButton(
                          "Envoyer aux membres du bureau", context, false, () {
                        CollectionReference sosRef = FirebaseFirestore.instance
                            .collection('MessageAuBureau');
                        FirebaseFirestore.instance
                            .collection('MessageAuBureau')
                            .add({
                          'message': _messageTextController.value.text,
                          "date": DateTime.now(),
                          "reponses": [],
                          "idAuteur": FirebaseAuth.instance.currentUser!.uid,
                          "likes": 0,
                        });
                        var i = 0;
                        for (var e in usersToken) {
                          sendPushMessage(
                              e!,
                              " ${_messageTextController.value.text} ",
                              "Blog: ${_messageTextController.value.text} ");
                          // addNotif(_messageTextController.value.text,
                          //     _messageTextController.value.text, usersId[i]);
                          i++;
                        }
                        i = 0;
                        //  Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text("Buteur"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "Votre message a été envoyé aux membres du bureau des élèves"),
                                  ],
                                )));
                      }),
                    ])))));
  }
}
