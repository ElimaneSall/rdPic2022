import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/model/article.dart';
import 'package:tuto_firebase/blog/screen/detail_article.dart';
import 'package:tuto_firebase/blog/sidebar/nav_drawer.dart';
import 'package:tuto_firebase/blog/widget/article_card.dart';
import 'package:intl/intl.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class ArticleParCategorie extends StatefulWidget {
  String categorie;
  String role;
  ArticleParCategorie(this.categorie, this.role, {Key? key}) : super(key: key);

  @override
  State<ArticleParCategorie> createState() => _ArticleParCategorieState(
        this.categorie,
        this.role,
      );
}

class _ArticleParCategorieState extends State<ArticleParCategorie> {
  String _categorie;
  String _role;
  _ArticleParCategorieState(this._categorie, this._role);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _articles = FirebaseFirestore.instance
        .collection('Article')
        .where("categorie", isEqualTo: _categorie)
        .snapshots();
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary),
      drawer: NavBar(_role),
      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Liste des articles de la sous-commission $_categorie",
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
                        stream: _articles,
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: (snapshot.data! as QuerySnapshot)
                                    .docs
                                    .map((e) => ArticleCard(Article(
                                        commentaire: e['commentaires'],
                                        id: e.id,
                                        idUser: e["idUser"],
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
    //     ],)
    //     ListView(
    //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
    //         Map<String, dynamic> data =
    //             document.data()! as Map<String, dynamic>;
    //         return InkWell(
    //             onTap: () {
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => DetailArticle(
    //                             document.id,
    //                           )));
    //             },
    //             child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       ClipRRect(
    //                           borderRadius: BorderRadius.circular(20),
    //                           child: Container(
    //                               width: 130,
    //                               height: 110,
    //                               child: Image.network(
    //                                 data['image'],
    //                                 fit: BoxFit.cover,
    //                               ))),
    //                       SizedBox(
    //                         width: 20,
    //                       ),
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             data['titre'],
    //                             //document.id,
    //                             style: TextStyle(
    //                               fontSize: 20,
    //                               fontWeight: FontWeight.w500,
    //                               color: AppColors.softBlue,
    //                               //decoration: TextDecoration.lineThrough
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: 4,
    //                           ),
    //                           Text(
    //                             data['auteur'],
    //                             style: TextStyle(
    //                               fontSize: 15,
    //                               fontWeight: FontWeight.w500,
    //                               color: Colors.yellow,
    //                               //decoration: TextDecoration.lineThrough
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: 4,
    //                           ),
    //                           Text(
    //                             data['date'],
    //                             style: TextStyle(
    //                                 fontSize: 12,
    //                                 fontWeight: FontWeight.w300,
    //                                 color: Colors.green),
    //                           )
    //                         ],
    //                       )
    //                     ],
    //                   ),
    //                   SizedBox(
    //                     height: 20,
    //                   )
    //                 ]));
    //       }).toList(),
    //     ),
    //   );
    // },

    ;
  }
}
