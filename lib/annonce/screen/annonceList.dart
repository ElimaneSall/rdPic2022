import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';
import 'package:tuto_firebase/annonce/sideBar/sideBar.dart';
import 'package:tuto_firebase/annonce/widget/annonceCard.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class AnnonceList extends StatefulWidget {
  const AnnonceList({Key? key}) : super(key: key);

  @override
  State<AnnonceList> createState() => _AnnonceListState();
}

class _AnnonceListState extends State<AnnonceList> {
  String role = "user";

  var cancelToken;
  getRole() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        role = documentSnapshot.get("role");
        setState(() {});
      }
    });
  }

  UploadTask? task;
  String? _urlPDF;
  String? _name;
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
    getRole();
    super.initState();
  }

  Future<String> _getExternalStoragePath() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
  }

  Future _downloadAndSaveFileToStorage(
      BuildContext context, String urlPath, String fileName) async {
    try {
      final dirList = await _getExternalStoragePath();

      final path = dirList + "/$fileName";

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
      if (_fileFullPath != "") {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("Emplacement"),
                content: Text("Emplacement: $_fileFullPath")));
      }
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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference annonces = firestore.collection('Annonce');
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Annonce")),
          backgroundColor: AppColors.primary,
        ),
        drawer: NavBar(role),
        //backgroundColor: Colors.blue,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Column(
            children: [
              Text(
                "Liste des annonces récentes",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: 22,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream:
                      annonces.orderBy('date', descending: true).snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: (snapshot.data! as QuerySnapshot)
                              .docs
                              .map((e) => AnnonceCard(
                                  Annonce(
                                    id: e.id,
                                    idUser: e["idUser"],
                                    likes: e['likes'],
                                    unlikes: e['unlikes'],
                                    commentaires: e['commentaires'],
                                    titre: e['titre'],
                                    poste: e['poste'],
                                    date: e['date'],
                                    status: e['status'],
                                    // description: e['description'],
                                    urlFile: e['urlFile'],
                                    annonce: e['annonce'],
                                    // likes: e['likes']
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        child: Text(
                                          "Télécharger",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        onPressed: () async {
                                          print("tappp");
                                          final snackBar = SnackBar(
                                              content: const Text(
                                                  'Téléchargement en cours!'),
                                              action: SnackBarAction(
                                                label: 'Annuler',
                                                onPressed: () {
                                                  // Some code to undo the change.
                                                  cancelToken.cancel();
                                                },
                                              ));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);

                                          _downloadAndSaveFileToStorage(
                                              context,
                                              e["urlFile"],
                                              "${e["titre"]}.${e["extension"]}");

                                          setState(() {
                                            _isDownloading = !_isDownloading;
                                          });
                                        },
                                      ),
                                      //  builUploadStatus(task!)
                                    ],
                                  )))
                              .toList());
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ))));
  }
}
