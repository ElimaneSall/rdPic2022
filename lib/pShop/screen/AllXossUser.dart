import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AllXossUser extends StatefulWidget {
  String id;
  String idUser;
  AllXossUser(this.id, this.idUser);

  @override
  State<AllXossUser> createState() => _AllXossUserState(id, idUser);
}

class _AllXossUserState extends State<AllXossUser> {
  String _idXoss;
  String _idUser;
  _AllXossUserState(this._idXoss, this._idUser);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Detail client"),
          centerTitle: true,
        ),
        body: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: Center(
                child: Container(
                    padding: EdgeInsets.only(
                        left: 10, top: 20, right: 10, bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        // height: MediaQuery.of(context).size.height * 0.4,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(_idUser)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return Row(
                                    children: [Text("Anonyme")],
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> dataUser = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return Text(
                                    dataUser["prenom"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return Text("Anonyme");
                              }),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Xoss')
                                  .where("idUser",
                                      whereIn: [_idUser]).snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: (snapshot.data!
                                              as QuerySnapshot)
                                          .docs
                                          .map((dataXossUser) => Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        "Total",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Xoss",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        if (dataXossUser[
                                                            "statut"])
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                          ),
                                                        if (!dataXossUser[
                                                            "statut"])
                                                          Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                          )
                                                      ],
                                                    ),
                                                    for (final produit
                                                        in dataXossUser[
                                                            "produits"])
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Text(
                                                            "\u2022",
                                                            style: TextStyle(
                                                                fontSize: 30),
                                                          ),
                                                          Text(
                                                            produit,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          dataXossUser['prix']
                                                                  .toString() +
                                                              " FCFA",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Color.fromRGBO(
                                                                    139,
                                                                    137,
                                                                    129,
                                                                    1),
                                                            //decoration: TextDecoration.lineThrough
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      DateTime.parse(
                                                              dataXossUser[
                                                                      'date']
                                                                  .toDate()
                                                                  .toString())
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Color.fromRGBO(
                                                            91, 60, 30, 100),
                                                      ),
                                                    )
                                                  ]))
                                          .toList());
                                }

                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              })
                        ]))))));
  }
}
