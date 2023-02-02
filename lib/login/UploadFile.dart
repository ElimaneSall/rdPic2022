import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:path/path.dart' as Path;

import '../utils/method.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  UploadTask? task;
  File? file;
  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? Path.basename(file!.path) : "No select file";
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload file"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: selectFile,
            child: Text("Select"),
          ),
          Text(filename),
          ElevatedButton(onPressed: uploadFile, child: Text("Upload")),
          SizedBox(
            height: 20,
          ),
          task != null ? builUploadStatus(task!) : Container()
        ],
      ),
    );
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
    final urlDonload = await snapshot.ref.getDownloadURL();

    print("Url Download $urlDonload");
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
