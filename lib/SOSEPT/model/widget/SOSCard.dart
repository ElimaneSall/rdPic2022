import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/model/SOSModel.dart';
import 'package:tuto_firebase/SOSEPT/model/widget/DetailSOS.dart';
import 'package:tuto_firebase/SOSEPT/model/widget/RepondreSOS.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SOSCard extends StatelessWidget {
  final SOSModel sosModel;
  SOSCard(this.sosModel);
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailSOS(sosModel.id)));
                },
                child: Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                          future: users
                                              .doc(sosModel.idAuteur)
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  "Something went wrong");
                                            }

                                            if (snapshot.hasData &&
                                                !snapshot.data!.exists) {
                                              return Row(
                                                children: [Text("Anonyme")],
                                              );
                                            }

                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              Map<String, dynamic> dataUser =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return Container(
                                                  color: Colors.white,
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 20,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    "https://st.depositphotos.com/1011643/2013/i/950/depositphotos_20131045-stock-photo-happy-male-african-university-student.jpg"),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    dataUser[
                                                                        "prenom"],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    dataUser[
                                                                        "nom"],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    dataUser[
                                                                            "promo"] +
                                                                        " ème promo",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                  "${timeAgoCustom(DateTime.parse(sosModel.date.toDate().toString()))}")
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ));
                                            }
                                            return Text("Anonyme");
                                          }),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        sosModel.sos,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          //decoration: TextDecoration.lineThrough
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        dateCustomformat(DateTime.parse(
                                            sosModel.date.toDate().toString())),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                          //decoration: TextDecoration.lineThrough
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailSOS(
                                                              sosModel.id)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide.none,
                                                primary:
                                                    Colors.white, // background
                                                // foreground
                                              ),
                                              child: Text(
                                                "Voir reponses(" +
                                                    sosModel.reponse.length
                                                        .toString() +
                                                    ")",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )),
                                          Spacer(),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RepondreSOS(
                                                              sosModel.id)),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                side: BorderSide.none,
                                                primary:
                                                    AppColors.red, // background
                                                // foreground
                                              ),
                                              child: Text("Repondre")),
                                        ],
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 20,
                      )
                    ])))));
  }
}
