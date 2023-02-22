import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/EPTChat/model/twitter.dart';
import 'package:tuto_firebase/EPTChat/twitter/AddTweet.dart';

import 'package:tuto_firebase/EPTChat/twitter/TwitterCard.dart';

class HomeTwitter extends StatefulWidget {
  @override
  _HomeTwitterState createState() => _HomeTwitterState();
}

class _HomeTwitterState extends State<HomeTwitter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Column(
          children: <Widget>[
            //app bar
            Material(
              elevation: 5.0,
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.06),
                height: 56.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      //Profile icon
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "https://png.pngtree.com/element_our/md/20180506/md_5aeee44e137e1.jpg",
                        ),
                      ),

                      //Header text
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            'Home Twitter',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      //left icon
                      FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return Text("Document does not exist");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
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
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
                child: SingleChildScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Tweet")
                            .orderBy('date', descending: true)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                                children: (snapshot.data! as QuerySnapshot)
                                    .docs
                                    .map((e) => TweetView(
                                          Tweet(
                                              id: e.id,
                                              idUser: e["idUser"],
                                              date: e["date"],
                                              commentaires: e["commentaires"],
                                              urlFile: e["urlFile"],
                                              tweet: e["tweet"],
                                              likes: e["likes"]),
                                        ))
                                    .toList());
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })))
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: (() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTweet()));
              }),
              child: Icon(Icons.edit),
            ),
            SizedBox(
              height: 8,
            ),
            FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.camera),
            ),
          ],
        ));
  }
}
