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

class LancerSOS extends StatefulWidget {
  const LancerSOS({Key? key}) : super(key: key);

  @override
  State<LancerSOS> createState() => _LancerSOSState();
}

class _LancerSOSState extends State<LancerSOS> {
  TextEditingController _sosTextController = TextEditingController();
  TextEditingController _sosGroupTextController = TextEditingController();
  List<String> group = ['tout', '50', '49', '48', '47', '46'];
  String? selectedGroup = "tout";

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
          title: Center(child: Text("Lancer un SOS")),
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
                      reusableTextField("Ecris ton SOS", Icons.edit_sharp,
                          false, _sosTextController, Colors.blue),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.black)),
                        title: Row(children: [
                          Icon(
                            Icons.group,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text('Categorie groupe:'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: DropdownButton(
                                value: selectedGroup,
                                items: group
                                    .map((item) => DropdownMenuItem<String>(
                                          child: Text(item),
                                          value: item,
                                        ))
                                    .toList(),
                                onChanged: (item) => setState(
                                    () => selectedGroup = item as String?),
                              ))
                        ]),
                      ),
                      signInSignUpButton("Lancer le SOS", context, false, () {
                        CollectionReference sosRef =
                            FirebaseFirestore.instance.collection('SOS');
                        FirebaseFirestore.instance.collection('SOS').add({
                          'sos': _sosTextController.value.text,
                          'groupe': selectedGroup,
                          "date": DateTime.now(),
                          "reponses": [],
                          "idAuteur": FirebaseAuth.instance.currentUser!.uid,
                          "likes": 0,
                        });
                        var i = 0;
                        for (var e in usersToken) {
                          sendPushMessage(
                              e!,
                              " ${_sosTextController.value.text} ",
                              "Blog: ${_sosTextController.value.text} ");
                          addNotif(_sosTextController.value.text,
                              _sosTextController.value.text, usersId[i]);
                          i++;
                        }
                        i = 0;
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SuccessMessageSOS()));
                      }),
                    ])))));
  }
}
