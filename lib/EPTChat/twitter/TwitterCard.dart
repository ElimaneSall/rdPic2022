import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/EPTChat/model/twitter.dart';
import 'package:tuto_firebase/EPTChat/twitter/DetailTweet.dart';
import 'package:tuto_firebase/EPTChat/twitter/tweets.dart';
import 'package:tuto_firebase/EPTChat/twitter/tweets.dart';
import 'package:tuto_firebase/utils/method.dart';

// ignore: must_be_immutable

class TweetView extends StatelessWidget {
  final Tweet tweets;
  TweetView(this.tweets);
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: InkWell(
          onLongPress: () {
            if (FirebaseAuth.instance.currentUser!.uid == tweets.idUser) {
              openDialogDelete(context, tweets.id, "Tweet", "Tweet",
                  "Voulez vous vraiment supprimer ce tweet");
            }
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailTweet(tweets.id)));
          },
          child: Container(
            padding: EdgeInsets.only(top: 6, bottom: 5),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(tweets.idUser)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> dataUser1 =
                            snapshot.data!.data() as Map<String, dynamic>;
                        // role = dataUser["role"];
                        return CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            dataUser1["urlProfile"],
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(tweets.idUser)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Something went wrong");
                                  }

                                  if (snapshot.hasData &&
                                      !snapshot.data!.exists) {
                                    return Text("Document does not exist");
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Map<String, dynamic> dataUser =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    // role = dataUser["role"];
                                    return Container(
                                        // color: Colors.grey,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Row(children: [
                                            Text(
                                              dataUser["prenom"],
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Icon(
                                              Icons.verified,
                                              size: 17,
                                              color: Colors.blue,
                                            ),
                                            Text(
                                              dataUser["nom"],
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width:
                                            //       MediaQuery.of(context).size.width *
                                            //           0.2,
                                            // ),
                                          ]),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${timeAgoCustom(DateTime.parse(tweets.date.toDate().toString()))}",
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                          )
                                        ]));
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            tweets.tweet,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        tweets.urlFile != ''
                            ? Material(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    tweets.urlFile,
                                    height: 150.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : SizedBox(height: 0.0),
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
                                            tweets.id,
                                            "Tweet"))),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(tweets.commentaires.length
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
                                        addLikes(
                                            tweets.id, "Tweet", tweets.likes);
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(tweets.likes.toString()),
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
                                      child: Text(tweets.likes.toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
