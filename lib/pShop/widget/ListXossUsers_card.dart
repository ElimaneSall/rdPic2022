import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/pShop/model/xoss.dart';
import 'package:tuto_firebase/pShop/screen/AllXossUser.dart';
import 'package:tuto_firebase/pShop/screen/detailXossUser.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tuto_firebase/utils/method.dart';

class ListXossUsers extends StatelessWidget {
  final Xoss xoss;
  ListXossUsers(this.xoss);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AllXossUser(xoss.id, xoss.idUser)),
        );
        ;
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(left: 10, top: 20, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(xoss.idUser)
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

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> dataUser =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    dataUser["prenom"] +
                                        " - " +
                                        dataUser["promo"] +
                                        " ème promo",
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                if (xoss.statut)
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  ),
                                if (!xoss.statut)
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                  )
                              ],
                            );
                          }
                          return Text("Anonyme");
                        }),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            ),
            Text(
              dateCustomformat(DateTime.parse(xoss.date.toDate().toString())),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color.fromRGBO(91, 60, 30, 100),
              ),
            ),
          ])),
    );
  }
}
