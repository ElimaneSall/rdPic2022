import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/utils/method.dart';
import 'package:path/path.dart' as Path;
import '../utils/color/color.dart';
import '../widget/reusableTextField.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _promoTextController = TextEditingController();
  TextEditingController _classeTextController = TextEditingController();
  UploadTask? task;
  File? file;
  String? urlFile;

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
    await FirebaseFirestore.instance
        .collection("UserToken")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "token": token,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? Path.basename(file!.path) : "No select file";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          centerTitle: true,
          title: Text('Modifier ses informations'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  reusableTextField("Nom", Icons.edit_sharp, false,
                      _nameTextController, Colors.blue),

                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Prenom", Icons.edit_sharp, false,
                      _userNameTextController, Colors.blue),

                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Telephone", Icons.edit_sharp, false,
                      _phoneTextController, Colors.blue),

                  SizedBox(
                    height: 10,
                  ),

                  reusableTextField("Email", Icons.edit_sharp, false,
                      _emailTextController, Colors.blue),
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Promo", Icons.edit_sharp, false,
                      _promoTextController, Colors.blue),

                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField("Classe", Icons.edit_sharp, false,
                      _classeTextController, Colors.blue),

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
                        child: Text("Photo de profil"),
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
                  //  Text("extension${filename.split(".")[1]}"),
                  SizedBox(
                    height: 10,
                  ),
                  task != null ? builUploadStatus(task!) : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton("Modifier votre profil", context, false,
                      () {
                    saveToken(mtoken!);
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                        .update({
                      'email': _emailTextController.value.text,
                      'promo': _promoTextController.value.text,
                      'nom': _nameTextController.value.text,
                      "prenom": _userNameTextController.value.text,
                      "telephone": _phoneTextController.value.text,
                      // 'admin': false,
                      // "role": "user",
                      "classe": _classeTextController.value.text,
                      "urlProfile": urlFile == null
                          ? "https://w7.pngwing.com/pngs/798/436/png-transparent-computer-icons-user-profile-avatar-profile-heroes-black-profile-thumbnail.png"
                          : urlFile,
                      "token": mtoken,
                      "id": FirebaseAuth.instance.currentUser!.uid.toString()
                    });

                    Navigator.pop(context);
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
