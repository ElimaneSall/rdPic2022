import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/utils/method.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailTweet extends StatefulWidget {
  String id;
  DetailTweet(this.id, {super.key});

  @override
  State<DetailTweet> createState() => _DetailTweetState(id);
}

class _DetailTweetState extends State<DetailTweet> {
  String _id;
  _DetailTweetState(this._id);

  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    CollectionReference xoss = FirebaseFirestore.instance.collection('Tweet');
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: xoss.doc(_id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Tweet",
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
              ),
              body: Container(
                  margin: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                      future: users.doc(data["idUser"]).get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }

                                        if (snapshot.hasData &&
                                            !snapshot.data!.exists) {
                                          return Text(
                                              "Document does not exist");
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
                                                            dataUser[
                                                                "urlProfile"],
                                                          )),
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
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: 3,
                                                              ),
                                                              Text(
                                                                dataUser["nom"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(timeAgoCustom(
                                                              DateTime.parse(data[
                                                                      'date']
                                                                  .toDate()
                                                                  .toString())))
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
                                    height: 10,
                                  ),
                                  Text(
                                    data["tweet"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )),
                            ),
                          )
                        ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                        child: Icon(
                                          Icons.comment,
                                          color: Colors.grey,
                                          size: 20.0,
                                        ),
                                        onTap: (() => commentOpenDiallog(
                                                    context,
                                                    _controller,
                                                    _id,
                                                    "Tweet")
                                                .then((value) {
                                              setState(() {
                                                xoss = FirebaseFirestore
                                                    .instance
                                                    .collection('Tweet');
                                              });
                                            }))),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(data["commentaires"]
                                          .length
                                          .toString()),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.grey,
                                        size: 20.0,
                                      ),
                                      onTap: () {
                                        addLikes(_id, "Tweet", data["likes"]);
                                        //  initState();
                                        setState(() {
                                          xoss = FirebaseFirestore.instance
                                              .collection('Tweet');
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(data["likes"].toString()),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.share,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(data["likes"].toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            Column(
                              children: [
                                for (final reponse in data["commentaires"])
                                  Column(children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.grey)),
                                          // borderRadius:
                                          //     BorderRadius.circular(10)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<DocumentSnapshot>(
                                                future: users
                                                    .doc(reponse["idUser"])
                                                    .get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        "Something went wrong");
                                                  }

                                                  if (snapshot.hasData &&
                                                      !snapshot.data!.exists) {
                                                    return Text(
                                                        "Document does not exist");
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    Map<String, dynamic>
                                                        dataUser =
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>;
                                                    // role = dataUser["role"];
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
                                                                      dataUser[
                                                                          "urlProfile"],
                                                                    )),
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          dataUser[
                                                                              "prenom"],
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              3,
                                                                        ),
                                                                        Text(
                                                                          dataUser[
                                                                              "nom"],
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Text(timeAgoCustom(DateTime.parse(reponse[
                                                                            'date']
                                                                        .toDate()
                                                                        .toString())))
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
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(reponse['commentaire']),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(dateCustomformat(
                                                    DateTime.parse(
                                                        reponse['date']
                                                            .toDate()
                                                            .toString())))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ])
                              ],
                            )
                          ],
                        )
                      ])));
        }

        return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }
}
