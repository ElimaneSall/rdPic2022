import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/model/article.dart';
import 'package:tuto_firebase/blog/sidebar/nav_drawer.dart';
import 'package:tuto_firebase/blog/widget/article_card.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class HomeArticle extends StatefulWidget {
  const HomeArticle({Key? key}) : super(key: key);

  @override
  State<HomeArticle> createState() => _HomeArticleState();
}

class _HomeArticleState extends State<HomeArticle> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection('Article');
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary),
      drawer: NavBar(),
      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Liste des articles récentes",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: products
                            .orderBy('date', descending: false)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: (snapshot.data! as QuerySnapshot)
                                    .docs
                                    .map((e) => ArticleCard(Article(
                                        commentaire: e['commentaires'],
                                        id: e.id,
                                        urlPDF: e['urlPDF'],
                                        image: e['image'],
                                        titre: e['titre'],
                                        date: e['date'],
                                        description: e['description'],
                                        auteur: e['auteur'],
                                        likes: e['likes'])))
                                    .toList());
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })
                  ],
                ),
              ))),
    );
  }
}
