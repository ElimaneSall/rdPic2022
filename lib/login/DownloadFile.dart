import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart' as p;

class DownloadFile extends StatefulWidget {
  const DownloadFile({super.key});

  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  late String _fileFullPath = "";
  late String progress;
  double progresso = 0.0;
  bool _isLoading = false;
  late Dio dio;
  bool _isDownloading = false;
  String downloadMessage = "Cliquer pour telecharger";
  double _pourcentage = 0.0;

  late double progression;
  @override
  void initState() {
    dio = Dio();
    super.initState();
  }

  Future<String> _getExternalStoragePath() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  }

  Future _downloadAndSaveFileToStorage(
      BuildContext context, String urlPath) async {
    try {
      final dirList = await _getExternalStoragePath();

      final path = dirList + "/sall.pdf";
      // final file = File('$path/sall.pdf');
      // final Directory _documentDir = Directory('/storage/emulated/0/Download/$name');
      await dio.download(urlPath, path, onReceiveProgress: (rec, total) {
        setState(() {
          _isLoading = true;
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          print(progress);
          var pourcentage = rec / total * 100;
          progression = (rec * 100) / total;
          if (_pourcentage <= 100) {
            _pourcentage = rec / total;
            downloadMessage = "Telechargement...${pourcentage.floor()} %";
          } else {
            _pourcentage = rec / total;
            downloadMessage = "Terminer...${pourcentage.floor()} %";
          }
        });
      });
      _fileFullPath = path;
    } catch (e) {
      // pr.close();
      print(e);
    }
  }

  @override
  void setState(VoidCallback fn) {
    _isLoading = false;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FloatingActionButton.extended(
              onPressed: () async {
                _downloadAndSaveFileToStorage(
                  context,
                  "https://firebasestorage.googleapis.com/v0/b/tuto-firebase-ninja.appspot.com/o/Cours_1.pdf",
                );

                setState(() {
                  _isDownloading = !_isDownloading;
                });
              },
              label: Text("Download"),
              icon: Icon(Icons.file_download),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            downloadMessage,
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: LinearProgressIndicator(value: _pourcentage),
          ),
          SizedBox(
            height: 30,
          ),
          if (_fileFullPath != "")
            Text(
              "Emplacement:" + _fileFullPath,
              // ignore: prefer_const_constructors
              style: TextStyle(
                backgroundColor: Colors.blue,
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
        ],
      )),
    );
  }
}
