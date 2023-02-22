import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tuto_firebase/services/notification.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';
import 'package:path/path.dart' as Path;

class AddStatus extends StatefulWidget {
  const AddStatus({super.key});

  @override
  State<AddStatus> createState() => _AddStatusState();
}

class _AddStatusState extends State<AddStatus> {
  final titrecontroller = TextEditingController();
  final annoncecontroller = TextEditingController();
  final auteurcontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final postecontroller = TextEditingController();
  final statuscontroller = TextEditingController();

  List<String> status = ['Texte', 'Image', 'Video'];
  String? selectedStatus = "Texte";
  List userId = [];
  List userToken = [];
  bool? nouvelleStatus;
  void checkDoc() {
    try {
      var doc = FirebaseFirestore.instance
          .collection("Status")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((doc) {
        nouvelleStatus = doc.exists;
        setState(() {});
      });
    } catch (e) {}
  }

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
    checkDoc();
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

  UploadTask? task;
  File? file;
  String? urlFile;
  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? Path.basename(file!.path) : "No select file";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text('Poster un status'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.white)),
                    title: Row(children: [
                      Text('Type: '),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: DropdownButton(
                            value: selectedStatus,
                            items: status
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) => setState(
                                () => selectedStatus = item as String?),
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Status", Icons.edit_sharp, false,
                      annoncecontroller, Colors.blue),
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Description", Icons.edit_sharp, false,
                      titrecontroller, Colors.blue),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (() {
                          selectFile();
                        }),
                        child: Text("Select file"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            uploadFile();
                          }),
                          child: Text("Upload")),
                    ],
                  ),
                  Text(filename),
                  SizedBox(
                    height: 10,
                  ),
                  task != null ? builUploadStatus(task!) : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton("Poster", context, false, () {
                    try {
                      if (nouvelleStatus!)
                        FirebaseFirestore.instance
                            .collection('Status')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({
                          "idUser": FirebaseAuth.instance.currentUser!.uid,
                          "status": FieldValue.arrayUnion([
                            {
                              "idUser": FirebaseAuth.instance.currentUser!.uid,
                              "date": DateTime.now(),
                              "type": selectedStatus,
                              'status': annoncecontroller.value.text,
                              "urlFile": urlFile == null ? "" : urlFile,
                            }
                          ]),
                        });
                      else {
                        FirebaseFirestore.instance
                            .collection('Status')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set(
                                // .doc(FirebaseAuth.instance.currentUser!.uid)
                                {
                              "idUser": FirebaseAuth.instance.currentUser!.uid,
                              "status": FieldValue.arrayUnion([
                                {
                                  "idUser":
                                      FirebaseAuth.instance.currentUser!.uid,
                                  "date": DateTime.now(),
                                  "type": selectedStatus,
                                  'status': annoncecontroller.value.text,
                                  "urlFile": urlFile == null ? "" : urlFile,
                                }
                              ]),
                            });
                      }
                      ;
                      var i = 0;
                      for (var e in userToken) {
                        sendPushMessage(e!, " ${annoncecontroller.value.text} ",
                            "Status: ${titrecontroller.value.text} ");
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = Path.basename(file!.path);
    final destination = "files/$fileName";
    task = FirebaseApi.uploadFile(destination, file!);

    setState(() {});
    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlFile = await snapshot.ref.getDownloadURL();
    setState(() {});

    print("Url Download $urlFile");
  }

  Widget builUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text("$percentage %");
          } else {
            return Container();
          }
        },
      );
}