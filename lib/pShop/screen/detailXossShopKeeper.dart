import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuto_firebase/notifications/model/notifications.dart';
import 'package:tuto_firebase/services/notification.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailXossShopKeeper extends StatefulWidget {
  String id;
  DetailXossShopKeeper(this.id);
  @override
  State<DetailXossShopKeeper> createState() => _DetailXossShopKeeperState(id);
}

class _DetailXossShopKeeperState extends State<DetailXossShopKeeper> {
  String _id;

  TextEditingController prixController = TextEditingController();

  String? mtoken;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? token;
  _DetailXossShopKeeperState(this._id);
  void updateStatut(String docID, bool statut) {
    try {
      FirebaseFirestore.instance.collection('Xoss').doc(docID).update({
        'statut': !statut,
      }).then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteStatut(String docID) {
    try {
      FirebaseFirestore.instance
          .collection('Xoss')
          .doc(docID)
          .delete()
          .then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    getToken();
    initInfo();
    //getTokenShop();
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

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      // saveToken(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Détail"),
          centerTitle: true,
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10)),
                        // height: MediaQuery.of(context).size.height * 0.4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('Xoss')
                                    .doc(_id)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }

                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return Row(
                                      children: [Text("Anonyme")],
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> dataXoss =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            FutureBuilder<DocumentSnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('Users')
                                                    .doc(dataXoss["idUser"])
                                                    .get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        "Something went wrong");
                                                  }

                                                  if (snapshot.hasData &&
                                                      !snapshot.data!.exists) {
                                                    return Row(
                                                      children: [
                                                        Text("Anonyme")
                                                      ],
                                                    );
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    Map<String, dynamic>
                                                        dataUser =
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>;

                                                    token = dataUser["token"];
                                                    print("TokenBi $token");
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          dataUser["prenom"] +
                                                              "-" +
                                                              dataUser[
                                                                  "promo"] +
                                                              " ème promo",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        if (dataXoss['statut'])
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                          ),
                                                        if (!dataXoss['statut'])
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                          )
                                                      ],
                                                    );
                                                  }
                                                  return Text("Anonyme");
                                                }),
                                            for (final produit
                                                in dataXoss["produits"])
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    "\u2022",
                                                    style:
                                                        TextStyle(fontSize: 30),
                                                  ),
                                                  Text(
                                                    produit,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            Center(
                                              child: Container(
                                                height: 30,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: AppColors.primary),
                                                child: Center(
                                                    child: Text(
                                                  dataXoss["prix"].toString() +
                                                      " FCFA",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                              ),
                                            ),
                                            if (!dataXoss["statut"])
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .red, // background
                                                        onPrimary: Colors
                                                            .black, // foreground
                                                      ),
                                                      onPressed: () {
                                                        sendPushMessage(
                                                            token!,
                                                            "Nous vous rappelons que vous avez payé un xoss impayé d'une valeur de ${dataXoss["prix"]}",
                                                            "Xoss");
                                                      },
                                                      child: Text("Rappeler")),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .green, // background
                                                        onPrimary: Colors
                                                            .black, // foreground
                                                      ),
                                                      onPressed: () {
                                                        updateStatut(_id,
                                                            dataXoss["statut"]);
                                                        //   print("Token bi$token");
                                                        sendPushMessage(
                                                            token!,
                                                            "Vous avez payé votre xoss d'une valeur de ${dataXoss["prix"]}",
                                                            "Xoss");
                                                      },
                                                      child: Text("Payer")),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .yellow, // background
                                                        onPrimary: Colors
                                                            .black, // foreground
                                                      ),
                                                      onPressed: () {
                                                        openDiallog(
                                                            context,
                                                            prixController,
                                                            _id,
                                                            "Xoss",
                                                            "prix",
                                                            "Modifier le prix",
                                                            "Entrer le montant restant",
                                                            "modifier");
                                                      },
                                                      child: Text("Avance")),
                                                ],
                                              ),
                                            if (dataXoss["statut"])
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .red, // background
                                                        onPrimary: Colors
                                                            .black, // foreground
                                                      ),
                                                      onPressed: () {
                                                        deleteStatut(_id);
                                                      },
                                                      child: Text("Supprimer")),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .green, // background
                                                        onPrimary: Colors
                                                            .black, // foreground
                                                      ),
                                                      onPressed: () {
                                                        updateStatut(_id,
                                                            dataXoss["statut"]);
                                                        sendPushMessage(
                                                            token!,
                                                            "Vous n'avez payé pas votre xoss d'une valeur de ${dataXoss["prix"]}",
                                                            "Xoss");
                                                      },
                                                      child: Text("Impaye")),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.02,
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .yellow, // background
                                                        onPrimary: Colors
                                                            .black, // foreground
                                                      ),
                                                      onPressed: (() {
                                                        sendPushMessage(
                                                            token!,
                                                            "Nous vous rappelons que vous avez payé un xoss impayé d'une valeur de ${dataXoss["prix"]}",
                                                            "Xoss");
                                                      }),
                                                      child: Text("Rappeler")),
                                                ],
                                              ),
                                          ],
                                        ));
                                  }
                                  return Text("Anonyme");
                                }),
                          ],
                        ))))));
  }
}
