import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/model/article.dart';
import 'package:tuto_firebase/blog/screen/commentArticlePage.dart';
import 'package:tuto_firebase/blog/screen/lirePDF.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class DetailArticle extends StatefulWidget {
  String id;
  String url;
  String auteur;
  String image;
  int likes;
  String date;
  String titre;
  List commentaire;

  DetailArticle(this.id, this.url, this.image, this.auteur, this.likes,
      this.date, this.titre, this.commentaire,
      {Key? key})
      : super(key: key);

  @override
  State<DetailArticle> createState() => _DetailArticleState(
      id, url, image, likes, auteur, date, titre, commentaire);
}

class _DetailArticleState extends State<DetailArticle> {
  String _id;
  String _url;
  String _auteur;
  String _image;
  int _likes;
  String _date;
  String _titre;
  List _commentaires;
  _DetailArticleState(this._id, this._url, this._image, this._likes,
      this._auteur, this._date, this._titre, this._commentaires);
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _articleStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Scaffold(
              appBar: AppBar(
                title: Center(child: Text("Detail de l'article")),
                backgroundColor: AppColors.primary,
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
                          _titre,
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
                          "Date: Le " + _date,
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
                            color: AppColors.softBlue,
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
                                                  CommentArticlePage(_id)));
                                    }),
                                SizedBox(
                                  width: 70,
                                ),
                                InkWell(
                                    child: Text(
                                      "Lire",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LirePDF(_url, _titre)));
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
                                        //   color: AppColors,
                                        decoration: BoxDecoration(
                                            color: AppColors.softBlue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
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
        });
  }
}
