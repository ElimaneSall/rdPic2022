import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/screen/commentEvenementPage.dart';
import 'package:tuto_firebase/annonce/screen/commentPage.dart';

class DetailEvenement extends StatefulWidget {
  String auteur;
  String image;
  int likes;
  String id;

  List commentaires;

  DetailEvenement(
      this.image, this.auteur, this.id, this.likes, this.commentaires,
      {Key? key})
      : super(key: key);

  @override
  State<DetailEvenement> createState() =>
      _DetailEvenementState(image, auteur, id, likes, commentaires);
}

class _DetailEvenementState extends State<DetailEvenement> {
  String _auteur;
  String _image;
  String _id;
  int _likes;

  List _commentaires;

  void addLikes(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('Evenement').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  _DetailEvenementState(
      this._image, this._auteur, this._id, this._likes, this._commentaires);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Detail Evemenent")),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Image.network(
                _image,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                fit: BoxFit.cover,
              ),
              Column(
                children: [
                  Text(
                    "AG",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "Posté par " + _auteur,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "Date: Le ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "Description:",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  ),
                  Text(
                    "Le Dark Web est un ensemble caché de sites Internet accessibles uniquement par un navigateur spécialement conçu à cet effet. Il est utilisé pour préserver l'anonymat et la confidentialité des activités sur Internet, ce qui peut être utile aussi bien pour les applications légales que pour les applications illégales",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      height: 40,
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    addLikes(_id, _likes);
                                  },
                                  icon: Icon(Icons.favorite)),
                              // SizedBox(height: 10,),
                              Text(_likes.toString())
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          InkWell(
                              child: Text(
                                "Comment",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommentEvenementPage(_id)));
                              }),
                          SizedBox(
                            width: 70,
                          ),
                          InkWell(
                              child: Text(
                                "Share",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommentPage(_id)));
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
                      Text("Commentaires", style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 10,
                      ),
                      for (final categorie in _commentaires)
                        Column(
                          children: [
                            Row(children: [
                              Icon(Icons.person),
                              SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  //   color: Colors.blue,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(categorie),
                                ),
                              )
                            ]),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                    ],
                  )
                ],
              )
            ])));
  }
}
