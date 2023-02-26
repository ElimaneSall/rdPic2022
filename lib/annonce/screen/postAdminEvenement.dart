import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tuto_firebase/services/notification.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/widget/reusableTextField.dart';

import '../../utils/method.dart';

class PostAdminEvenement extends StatefulWidget {
  const PostAdminEvenement({Key? key}) : super(key: key);

  @override
  State<PostAdminEvenement> createState() => _PostAdminEvenementState();
}

class _PostAdminEvenementState extends State<PostAdminEvenement> {
  final titrecontroller = TextEditingController();
  final imagecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final auteurcontroller = TextEditingController();
  final datecontroller = TextEditingController();

  final statuscontroller = TextEditingController();
  List<String> postes = [
    'Présidence',
    'Sécrétariat général',
    'Commission Pédagogique',
    'Commission Sociale',
    'Commission Finance',
    'Commission Relation Extérieure',
    'Commission Restauration',
    'Commission Culturelle',
    'Commission Sport',
    'Trésorie Générale',
  ];
  String? selectedPoste = 'Sécrétariat général';
  DateTime selectedDate = DateTime.now();
  List<String> status = ['urgent', 'Moins Urgent', 'Facultatif'];
  String? selectedStatus = "urgent";

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  bool loading = false;
  String url = "";
  String filename = "";
  Future<void> uploadImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    filename = pickedImage.name;
    File imageFile = File(pickedImage.path);

    Reference reference = firebaseStorage.ref(filename);

    try {
      setState(() {
        loading = true;
      });
      await reference.putFile(imageFile);
      url = (await reference.getDownloadURL()).toString();

      setState(() async {
        loading = false;
        url = (await reference.getDownloadURL()).toString();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success upload")));

      print("SamaUrl" + url);
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

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
          centerTitle: true,
          title: Text('Poster un evenement'),
          backgroundColor: AppColors.primary,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(color: Colors.white)),
                    title: Row(children: [
                      Text('Poste:'),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: DropdownButton(
                            value: selectedPoste,
                            items: postes
                                .map((item) => DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) =>
                                setState(() => selectedPoste = item as String?),
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  reusableTextField(
                      "Titre", Icons.add, false, titrecontroller, Colors.blue),
                  SizedBox(
                    height: 15,
                  ),
                  reusableTextField("Description", Icons.add, false,
                      descriptioncontroller, Colors.blue),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Statut'),
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
                          )),
                    ],
                  ),
                  InputDatePickerFormField(
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                    initialDate: selectedDate,
                    onDateSubmitted: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ElevatedButton.icon(
                        onPressed: () async {
                          await uploadImage();
                        },
                        icon: Icon(
                          Icons.library_add,
                        ),
                        label: Text("Image"),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Text('Select date'),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  signInSignUpButton(
                    "Poster",
                    context,
                    false,
                    () async {
                      await FirebaseFirestore.instance
                          .collection('Evenement')
                          .add({
                        'titre': titrecontroller.value.text,
                        'description': descriptioncontroller.value.text,
                        'date': selectedDate,
                        "auteur": "",
                        'extension':
                            filename == "" ? "" : filename.split(".")[1],
                        'poste': selectedPoste,
                        'status': statuscontroller.value.text,
                        "image": url,
                        "idUser": FirebaseAuth.instance.currentUser!.uid,
                        'commentaires': [],
                        'likes': 0,
                        'unlikes': 0,
                      });
                      var i = 0;
                      for (var e in userToken) {
                        sendPushMessage(
                            e!,
                            " ${descriptioncontroller.value.text} ",
                            "BDE: ${titrecontroller.value.text} ");
                        addNotif(titrecontroller.value.text,
                            titrecontroller.value.text, userId[i]);
                        i++;
                      }
                      i = 0;
                      Navigator.pop(context);
                    },
                  )
                ]))));
  }
}
