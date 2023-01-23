
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as p;

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';



class LirePDF extends StatefulWidget {
  String url;
  String name;
  LirePDF(this.url, this.name, {Key? key}) : super(key: key);

  @override
  State<LirePDF> createState() => _LirePDFState(url, name);
}

class _LirePDFState extends State<LirePDF> {

  String _urlPDF;
  String _name;
  late String _fileFullPath = "";
  late String progress;
  double progresso = 0.0;
  bool _isLoading = false;
  late Dio dio;
  bool _isDownloading = false;
  String downloadMessage = "Cliquer pour telecharger";
  double _pourcentage=0.0;
  
  late double progression;

  _LirePDFState(this._urlPDF, this._name);
  @override
  void initState(){
    dio = Dio();
    super.initState();
  }

  Future<List<Directory>?> _getExternalStoragePath(){
    return p.getExternalStorageDirectories(type: p.StorageDirectory.documents);
  }

  Future _downloadAndSaveFileToStorage(
   BuildContext context, String urlPath, String fileName) async {

    try {
      final dirList = await _getExternalStoragePath();
      
      final path = dirList![0].path;
      final file = File('$path/$fileName');
     // final Directory _documentDir = Directory('/storage/emulated/0/Download/$name');
      await dio.download(urlPath, file.path, onReceiveProgress: (rec, total) {
        setState((){
          _isLoading = true;
          progress = ((rec/total)*100).toStringAsFixed(0) + "%";
          print(progress);
          var pourcentage = rec / total *100;
          progression = (rec*100)/total;
          if(_pourcentage<=100){
          _pourcentage = rec/total;
          downloadMessage = "Telechargement...${pourcentage.floor()} %";
          }else{
            _pourcentage = rec/total;
             downloadMessage = "Terminer...${pourcentage.floor()} %";
          }
        });
      });
      _fileFullPath = file.path;
    }catch(e){
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
         appBar: AppBar(
            title: Text("Telecharger l'article \""+_name+ "\""),
            centerTitle: true,
            backgroundColor: Colors.blue
         ),
          body: Container(
            child: Column(
              crossAxisAlignment:  CrossAxisAlignment.center,
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Center(
                  child:FloatingActionButton.extended(
                  onPressed: () async{
                    _downloadAndSaveFileToStorage(context, _urlPDF, "$_name.pdf");
                
                    setState(() {
                      _isDownloading = ! _isDownloading;
                    });
                  }, 
                  label: Text("Download"),
                  icon:Icon(Icons.file_download),),
                   
                ),
                SizedBox(height: 30,),
                  Text(downloadMessage ,
                  style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: LinearProgressIndicator(value: _pourcentage),
                  ),
                  SizedBox(height: 30,),
                  if(_fileFullPath!="")
                  Text(
                    "Emplacement:"+_fileFullPath,
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      backgroundColor: Colors.blue,
                      fontSize: 15,
                      color: Colors.white,                      
                       ),
                       textAlign: TextAlign.center,
                  )
              ],
            )
          )
    );
  }
}