import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/model/article.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';
import 'package:path_provider/path_provider.dart' as p;

class DetailArticle extends StatefulWidget {
  String id;

  DetailArticle(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailArticle> createState() => _DetailArticleState(
        id,
      );
}

class _DetailArticleState extends State<DetailArticle> {
  String _id;

  _DetailArticleState(this._id);
  final Stream<QuerySnapshot> _articleStream =
      FirebaseFirestore.instance.collection('Article').snapshots();

  void addLikes(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('Article').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  TextEditingController controller = TextEditingController();
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
  CancelToken cancelToken = CancelToken();

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
      BuildContext context, String urlPath, String fileName) async {
    try {
      final dirList = await _getExternalStoragePath();

      final path = dirList + "/$fileName";
      //final file = File('$path/$fileName');
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
      }, cancelToken: cancelToken);
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
    CollectionReference article =
        FirebaseFirestore.instance.collection('Article');
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Détail de l'article")),
          backgroundColor: AppColors.primary,
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
                future: article.doc(_id).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Row(
                      children: [Text("Anonyme")],
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> dataEvenement =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            dataEvenement["image"],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            children: [
                              Text(
                                dataEvenement["titre"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                              Text(
                                "Ecris par " + dataEvenement["auteur"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    decoration: TextDecoration.none),
                              ),
                              Text(
                                dateCustomformat(DateTime.parse(
                                    dataEvenement["date"].toDate().toString())),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    decoration: TextDecoration.none),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              // Text(
                              //   dataEvenement["poste"],
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 15,
                              //       decoration: TextDecoration.none),
                              // ),
                              Text(
                                "Description:",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    decoration: TextDecoration.none),
                              ),
                              Text(
                                dataEvenement["description"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    decoration: TextDecoration.none),
                              ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  height: 40,
                                  color: AppColors.primary,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                addLikes(_id,
                                                    dataEvenement["likes"]);
                                                setState(() {
                                                  article = FirebaseFirestore
                                                      .instance
                                                      .collection("Article");
                                                });
                                              },
                                              child: Icon(Icons.favorite)),
                                          // SizedBox(height: 10,),
                                          Text(
                                              dataEvenement["likes"].toString())
                                        ],
                                      ),
                                      InkWell(
                                          child: Text(
                                            "Commenter",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          onTap: () {
                                            commentOpenDiallog(context,
                                                controller, _id, "Article");
                                            setState(() {
                                              article = FirebaseFirestore
                                                  .instance
                                                  .collection("Article");
                                            });
                                          }),
                                      GestureDetector(
                                        child: Text(
                                          "Télécharger",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        onTap: () async {
                                          print("tappp");

                                          _downloadAndSaveFileToStorage(
                                              context,
                                              dataEvenement["urlPDF"],
                                              "${dataEvenement["titre"]}.pdf");
                                          final snackBar = SnackBar(
                                            content: const Text(
                                                'Téléchargement en cours!'),
                                            action: SnackBarAction(
                                              label: 'Annuler',
                                              onPressed: () {
                                                // Some code to undo the change.
                                                cancelToken.cancel();
                                              },
                                            ),
                                          );

                                          // Find the ScaffoldMessenger in the widget tree
                                          // and use it to show a SnackBar.
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);

                                          setState(() {
                                            _isDownloading = !_isDownloading;
                                          });
                                        },
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Commentaires",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  for (final commentaire
                                      in dataEvenement["commentaires"])
                                    Column(children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<DocumentSnapshot>(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection("Users")
                                                      .doc(
                                                          commentaire["idUser"])
                                                      .get(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot>
                                                          snapshot) {
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          "Something went wrong");
                                                    }

                                                    if (snapshot.hasData &&
                                                        !snapshot
                                                            .data!.exists) {
                                                      return Text(
                                                          "Document does not exist");
                                                    }

                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      Map<String, dynamic>
                                                          dataUser =
                                                          snapshot.data!.data()
                                                              as Map<String,
                                                                  dynamic>;
                                                      //  role = dataUser["role"];
                                                      return Container(
                                                          color: Colors.white,
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                      radius:
                                                                          20,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                        dataUser[
                                                                            "urlProfile"],
                                                                      )),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            dataUser["prenom"],
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            dataUser["nom"],
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(timeAgoCustom(DateTime.parse(commentaire[
                                                                              'date']
                                                                          .toDate()
                                                                          .toString())))
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ));
                                                    }
                                                    return Text("Anonyme");
                                                  }),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(commentaire[
                                                      'commentaire']),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    dateCustomformat(
                                                        DateTime.parse(
                                                            commentaire['date']
                                                                .toDate()
                                                                .toString())),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ])
                                ],
                              )
                            ],
                          )
                        ]);
                  }
                  return Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ));
                })));
  }
}
