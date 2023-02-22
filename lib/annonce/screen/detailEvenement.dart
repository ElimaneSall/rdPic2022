import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailEvenement extends StatefulWidget {
  String id;

  DetailEvenement(this.id, {Key? key}) : super(key: key);

  @override
  State<DetailEvenement> createState() => _DetailEvenementState(id);
}

class _DetailEvenementState extends State<DetailEvenement> {
  String _id;

  TextEditingController controller = TextEditingController();

  var role;

  _DetailEvenementState(this._id);

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
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Détail Evenement")),
          backgroundColor: AppColors.primary,
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Evenement')
                    .doc(_id)
                    .get(),
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
                            fit: BoxFit.cover,
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
                                "Posté par " + dataEvenement["auteur"],
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
                              Text(
                                dataEvenement["poste"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    decoration: TextDecoration.none),
                              ),
                              if (dataEvenement["description"] != "")
                                Column(
                                  children: [
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
                                  ],
                                ),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 40,
                                  color: AppColors.primary,
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                addLikes(_id, "Evenement",
                                                    dataEvenement["likes"]);
                                              },
                                              child: Icon(
                                                Icons.thumb_up,
                                                color: Colors.white,
                                              )),
                                          // SizedBox(height: 10,),
                                          Text(
                                            dataEvenement["likes"].toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                undLike(_id, "Evenement",
                                                    dataEvenement["unlikes"]);
                                              },
                                              child: Icon(
                                                Icons.thumb_down,
                                                color: Colors.white,
                                              )),
                                          // SizedBox(height: 10,),
                                          Text(
                                            dataEvenement["unlikes"].toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
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
                                                controller, _id, "Evenement");
                                          }),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      InkWell(
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
                                                dataEvenement["image"],
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
                                          })
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
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }
}
