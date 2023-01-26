import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/blog/model/article.dart';
import 'package:tuto_firebase/blog/screen/detail_article.dart';
import 'package:tuto_firebase/model/menu.dart';
import 'package:tuto_firebase/pShop/model/xoss.dart';
import 'package:tuto_firebase/pShop/screen/detailXossUser.dart';
import 'package:tuto_firebase/screen/detaitl_screen.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class XossUserCard extends StatelessWidget {
  final Xoss xoss;
  XossUserCard(this.xoss);
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailXossUser(xoss.id, xoss.statut)),
          );
          ;
        },
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Xossna",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (xoss.statut)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    if (!xoss.statut)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100)),
                      )
                  ],
                ),
                Container(
                    // width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.002,
                    ),
                    for (final produit in xoss.produit)
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "\u2022",
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            produit,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                  ],
                )),
                SizedBox(width: MediaQuery.of(context).size.width * 0.002),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeAgoCustom(
                          DateTime.parse(xoss.date.toDate().toString())),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(91, 60, 30, 100),
                      ),
                    ),
                    Text(
                      xoss.prix.toString() + " FCFA",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blue
                          //decoration: TextDecoration.lineThrough
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ]));
  }
}
