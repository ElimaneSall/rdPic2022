import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:tuto_firebase/utils/color/color.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailXossUser extends StatefulWidget {
  String id;
  bool _statut;
  DetailXossUser(this.id, this._statut);
  @override
  State<DetailXossUser> createState() => _DetailXossUserState(id, _statut);
}

class _DetailXossUserState extends State<DetailXossUser> {
  String _id;
  bool _statut;
  _DetailXossUserState(this._id, this._statut);
  Future<void> sendMail() async {
    try {
      var userEmail = "salleli@ept.sn";
      var message = Message();
      message.subject = "Test flutter";
      message.text = "Je test envoie de mail";
      message.from = Address(userEmail.toString());

      message.recipients.add(userEmail);

      var smtpServer = gmailRelaySaslXoauth2(userEmail, "");

      send(message, smtpServer);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text("Detail"),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    // height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
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
                                Map<String, dynamic> dataUser = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dataUser["prenom"] +
                                          dataUser["promo"] +
                                          " ??me promo",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (_statut)
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                      ),
                                    if (!_statut)
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
                        FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Xoss')
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

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> dataXoss = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                return Container(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (final produit
                                            in dataXoss["produits"])
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
                                          ),
                                        Center(
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppColors.primary),
                                            child: Center(
                                                child: Text(
                                              dataXoss["prix"].toString() +
                                                  " FCFA",
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          dateCustomformat(DateTime.parse(
                                              dataXoss["date"]
                                                  .toDate()
                                                  .toString())),
                                        ),
                                        if (!dataXoss["statut"])
                                          Center(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .green, // background
                                                  onPrimary: Colors
                                                      .black, // foreground
                                                ),
                                                onPressed: sendMail,
                                                child: Text(
                                                    "Signaler un payement")),
                                          ),
                                      ],
                                    ));
                              }
                              return Text("Anonyme");
                            }),
                      ],
                    )))));
  }
}
