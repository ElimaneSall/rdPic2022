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

class RD extends StatefulWidget {
  String categorie;
  RD(this.categorie, {Key? key}) : super(key: key);

  @override
  State<RD> createState() => _RDState(
        this.categorie,
      );
}

class _RDState extends State<RD> {
  String _categorie;
  _RDState(this._categorie);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _movieStream = FirebaseFirestore.instance
        .collection('Article')
        .where("categorie", isEqualTo: _categorie)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _movieStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          drawer: NavBar(),
          appBar: AppBar(
            title: Text(_categorie),
            centerTitle: true,
            backgroundColor: AppColors.primary,
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailArticle(
                                  document.id,
                                )));
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                    width: 130,
                                    height: 110,
                                    child: Image.network(
                                      data['image'],
                                      fit: BoxFit.cover,
                                    ))),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['titre'],
                                  //document.id,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.softBlue,
                                    //decoration: TextDecoration.lineThrough
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  data['auteur'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.yellow,
                                    //decoration: TextDecoration.lineThrough
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  data['date'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.green),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ]));
            }).toList(),
          ),
        );
      },
    );
    ;
  }
}
