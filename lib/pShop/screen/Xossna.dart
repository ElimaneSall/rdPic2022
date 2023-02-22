import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuto_firebase/notifications/model/notifications.dart';
import 'package:tuto_firebase/pShop/screen/SuccessMessage.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import '../../services/notification.dart';
import '../../widget/reusableTextField.dart';

class Xossna extends StatefulWidget {
  const Xossna({Key? key}) : super(key: key);

  @override
  State<Xossna> createState() => _XossnaState();
}

class _XossnaState extends State<Xossna> {
  TextEditingController _produitTextController = TextEditingController();
  TextEditingController _prixTextController = TextEditingController();
  List listProduit = [];
  double sum = 0;
  String? token;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? idReceveurNotif;
  void getSomme() {
    FirebaseFirestore.instance.collection('Xoss').get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if (result.data()["idUser"] ==
              FirebaseAuth.instance.currentUser!.uid) {
            sum = sum + result.data()['prix'];
          }
        });
        print("somme2$sum");
        setState(() {});
      },
    );
  }

  getTokenShop() {
    FirebaseFirestore.instance.collection('Users').get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          if (result.data()["role"] == "boutiquier") {
            token = result.data()['token'];
            idReceveurNotif = result.data()['idUser'];
          }
        });
        print("Token Boutiquier $token");
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getSomme();
    print("somme1$sum");
    ;
    initInfo();
    getTokenShop();
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
          title: Center(child: Text("Xossna")),
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
                      Text(sum.toString()),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Produit", Icons.add, false,
                          _produitTextController, Colors.blue),
                      SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Prix", Icons.add, false,
                          _prixTextController, Colors.blue),
                      signInSignUpButton("Xossna", context, false, () {
                        if (sum < 10000) {
                          listProduit =
                              _produitTextController.value.text.split(";");
                          FirebaseFirestore.instance.collection('Xoss').add({
                            'produits': FieldValue.arrayUnion(listProduit),
                            "prix": int.parse(_prixTextController.value.text),
                            "date": DateTime.now(),
                            "idUser": FirebaseAuth.instance.currentUser!.uid,
                            "statut": false
                          });
                          // CustomNotification.addNotification(
                          //     "2",
                          //     "Xoss",
                          //     "Un nouveau xoss d'une valeur de ${_prixTextController.value.text} FCFA a été fait",
                          //     "k6uD0t2S7oRmBw5Q49nydG7KhT22");
                          print("Token bi$token");
                          sendPushMessage(
                              token!,
                              "Un nouveau xoss d'une valeur de ${_prixTextController.value.text} FCFA a été fait.",
                              "Xoss");
                          FirebaseFirestore.instance.collection('Notifs').add({
                            'body': "body",
                            "title": "title",
                            "time": DateTime.now(),
                            "userId": idReceveurNotif,
                            "isActive": false,
                            "uid": ""
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuccessMessage()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  title: Text("Message"),
                                  content: Text(
                                    "Vous avez atteint la valeur maximale",
                                    textAlign: TextAlign.center,
                                  )));
                        }
                        ;
                      }),
                    ])))));
  }
}
