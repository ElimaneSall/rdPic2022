import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/model/article.dart';
import 'package:tuto_firebase/blog/screen/detail_article.dart';
import 'package:tuto_firebase/model/menu.dart';
import 'package:tuto_firebase/screen/detaitl_screen.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  ArticleCard(this.article);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          if (FirebaseAuth.instance.currentUser!.uid == article.idUser) {
            openDialogDelete(context, article.id, "Article",
                "Message de suppression", "Voulez vous supprimer cet article");
            // Navigator.pop(context);
          } else {}
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailArticle(
                        article.id,
                      )));
        },
        child: Column(children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.16,
                      child: Image.network(
                        article.image,
                        fit: BoxFit.fill,
                      ))),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        article.titre,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          //decoration: TextDecoration.lineThrough
                        ),
                      )),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    article.auteur,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.softBlue,
                      //decoration: TextDecoration.lineThrough
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    dateCustomformat(
                        DateTime.parse(article.date.toDate().toString())),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppColors.secondary),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          )
        ]));
  }
}
