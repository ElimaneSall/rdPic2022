import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';
import 'package:tuto_firebase/annonce/screen/annonceList.dart';
import 'package:tuto_firebase/annonce/screen/evenementsList.dart';

import 'package:tuto_firebase/annonce/sideBar/sideBar.dart';
import 'package:tuto_firebase/annonce/widget/annonceCard.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart' as p;

class HomeAnnonce extends StatefulWidget {
  const HomeAnnonce({Key? key}) : super(key: key);

  @override
  State<HomeAnnonce> createState() => _HomeAnnonceState();
}

class _HomeAnnonceState extends State<HomeAnnonce> {
  final Stream<QuerySnapshot> _evenementStream =
      FirebaseFirestore.instance.collection('Evenement').snapshots();
  final Stream<QuerySnapshot> _annonceStream = FirebaseFirestore.instance
      .collection('Annonce')
      .orderBy("date", descending: true)
      .snapshots();

  String role = "user";
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

  Future<List<Directory>?> _getExternalStoragePath() {
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
      _fileFullPath = file.path;
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
    initializeDateFormatting("fr");
    return Scaffold(
        drawer: NavBar(role),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Center(
              child: Text(
            "Polytech Info",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: _evenementStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 300,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              //onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Builder(
                                builder: (BuildContext context) {
                                  return Column(children: [
                                    Container(
                                        height: 235,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: Colors.white),
                                        child: Image.network(data["image"])),
                                    Text(data["titre"]),
                                  ]);
                                },
                              );
                            }).toList(),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 135,
                                  height: 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AnnonceList()),
                                        );
                                      },
                                      child: Text(
                                        "Annonce",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ))),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                  width: 135,
                                  height: 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EvenementList()),
                                        );
                                      },
                                      child: Text(
                                        "Evenement",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      )))
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Les annonces recentes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          //SizedBox(height: ,),

                          Row(
                            children: [
                              Container(
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                color: Colors.blue,
                              ),
                            ],
                          )
                        ])));
              }),
          SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _annonceStream,
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
                                  // Column(
                                  //   children: [
                                  //     ElevatedButton(
                                  //       child: Text(
                                  //         "Télécharger",
                                  //         style: TextStyle(
                                  //             color: Colors.black,
                                  //             fontSize: 15),
                                  //       ),
                                  //       onPressed: () async {
                                  //         print("tappp");

                                  //         _downloadAndSaveFileToStorage(
                                  //             context,
                                  //             e["urlFile"],
                                  //             "${e["titre"]}.pdf");

                                  //         setState(() {
                                  //           _isDownloading = !_isDownloading;
                                  //         });
                                  //       },
                                  //     ),
                                  //     //  builUploadStatus(task!)
                                  //   ],
                                  // )
                                  Container()))
                              .toList());
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))
        ])));
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
