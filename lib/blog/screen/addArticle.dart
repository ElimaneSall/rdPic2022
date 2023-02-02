import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:path/path.dart' as Path;

import '../../utils/method.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final auteurcontroller = TextEditingController();
  final categoriecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final imagecontroller = TextEditingController();
  final titrecontroller = TextEditingController();
  final urlcontroller = TextEditingController();

  UploadTask? taskImage;
  UploadTask? taskPDF;
  File? fileImage;
  File? filePDF;
  String? urlImage;
  String? urlPDF;
  @override
  Widget build(BuildContext context) {
    final filename =
        fileImage != null ? Path.basename(fileImage!.path) : "No select file";
    final filenamePDF =
        filePDF != null ? Path.basename(filePDF!.path) : "No select file";

    return Scaffold(
        appBar: AppBar(
          title: Text('Ajouter un article'),
          backgroundColor: AppColors.primary,
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.white)),
                title: Row(children: [
                  Text('Auteur:'),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: auteurcontroller,
                  ))
                ]),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.white)),
                title: Row(children: [
                  Text('titre:'),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: titrecontroller,
                  ))
                ]),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.white)),
                title: Row(children: [
                  Text('Categorie:'),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: categoriecontroller,
                  ))
                ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (() {
                          selectImageFile();
                        }),
                        child: Text("Select image"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            uploadImageFile();
                          }),
                          child: Text("Upload")),
                    ],
                  ),
                  Text(filename),
                  SizedBox(
                    height: 20,
                  ),
                  taskImage != null ? builUploadStatus(taskImage!) : Container()
                ],
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.white)),
                title: Row(children: [
                  Text('Description:'),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: descriptioncontroller,
                  ))
                ]),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (() {
                          selectPDFFile();
                        }),
                        child: Text("Select PDF"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: (() {
                            uploadPDFFile();
                          }),
                          child: Text("Upload")),
                    ],
                  ),
                  Text(filenamePDF),
                  SizedBox(
                    height: 20,
                  ),
                  taskPDF != null ? builUploadStatus(taskPDF!) : Container()
                ],
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Article').add({
                      'auteur': auteurcontroller.value.text,
                      'categorie': categoriecontroller.value.text,
                      'date': DateTime.now(),
                      'description': descriptioncontroller.value.text,
                      'image': urlImage,
                      'titre': titrecontroller.value.text,
                      'urlPDF': urlPDF,
                      "idUser": FirebaseAuth.instance.currentUser!.uid,
                      'likes': 0,
                      'commentaires': []
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Ajouter'))
            ])));
  }

  Future selectImageFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      fileImage = File(path);
    });
  }

  Future uploadImageFile() async {
    if (fileImage == null) return;

    final fileName = Path.basename(fileImage!.path);
    final destination = "files/$fileName";
    taskImage = FirebaseApi.uploadFile(destination, fileImage!);

    setState(() {});
    if (taskImage == null) return;

    final snapshot = await taskImage!.whenComplete(() {});
    urlImage = await snapshot.ref.getDownloadURL();
    setState(() {});

    print("Url Image Download $urlImage");
  }

  Future selectPDFFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      filePDF = File(path);
    });
  }

  Future uploadPDFFile() async {
    if (filePDF == null) return;

    final fileName = Path.basename(filePDF!.path);
    final destination = "files/$fileName";
    taskPDF = FirebaseApi.uploadFile(destination, filePDF!);

    setState(() {});
    if (taskPDF == null) return;

    final snapshot = await taskPDF!.whenComplete(() {});
    urlPDF = await snapshot.ref.getDownloadURL();
    setState(() {});

    print("Url PDF Download $urlPDF");
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
