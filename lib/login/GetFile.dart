import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class GetFile extends StatefulWidget {
  const GetFile({Key? key}) : super(key: key);

  @override
  State<GetFile> createState() => _GetFileState();
}

class _GetFileState extends State<GetFile> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref("/images").listAll();
  }

  @override
  Widget build(BuildContext context) {
    Future download(Reference ref) async {
      final url = await ref.getDownloadURL();
      final tempDir = await getTemporaryDirectory();
      final path = ' ${tempDir.path}/${ref.name}';
      await Dio().download(url, path);
      if (url.contains(".mp4")) {
        await GallerySaver.saveVideo(path, toDcim: true);
      } else {
        await GallerySaver.saveImage(path, toDcim: true);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Download${ref.name}")));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("get"),
        ),
        body: FutureBuilder<ListResult>(
            future: futureFiles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final files = snapshot.data!.items;
                return ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return ListTile(
                        title: Text(file.name),
                        trailing: IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () => download(file)),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("Erreur");
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text("Load");
            }));
  }
}
