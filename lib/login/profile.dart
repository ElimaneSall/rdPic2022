import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto_firebase/MessageAuBureau/widget/DetailMessage.dart';
import 'package:tuto_firebase/SOSEPT/screen/HomeSOS.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/login/EditProfile.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    initializeDateFormatting("fr");
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> dataUser =
                snapshot.data!.data() as Map<String, dynamic>;
            return (Container(
                child: new Stack(children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(colors: [
                  hexStringToColor("000"),
                  hexStringToColor("000"),
                  hexStringToColor("dd9933"),
                ], begin: Alignment.topCenter, end: Alignment.center)),
              ),
              new Scaffold(
                backgroundColor: Colors.transparent,
                body: new Container(
                  child: new Stack(
                    children: <Widget>[
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: new EdgeInsets.only(top: _height / 15),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new CircleAvatar(
                                backgroundImage:
                                    new NetworkImage(dataUser["urlProfile"]),
                                radius: _height / 10,
                              ),
                              new SizedBox(
                                height: _height / 30,
                              ),
                              new Text(
                                dataUser["prenom"] + " " + dataUser["nom"],
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dataUser["telephone"],
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dataUser["email"],
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(top: _height / 2.2),
                        child: new Container(
                          color: Colors.white,
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(
                            top: _height / 2.6,
                            left: _width / 20,
                            right: _width / 20),
                        child: Column(
                          children: <Widget>[
                            new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 2.0,
                                        offset: new Offset(0.0, 2.0))
                                  ]),
                              child: new Padding(
                                padding: new EdgeInsets.all(_width / 20),
                                child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      headerChild(
                                        'Promo',
                                        dataUser["promo"] + " ème promo",
                                      ),
                                      headerChild('Classe', dataUser["classe"]),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: new EdgeInsets.only(
                            top: _height / 2.15,
                            left: _width / 20,
                            right: _width / 20),
                        child: new Padding(
                          padding: new EdgeInsets.only(top: _height / 20),
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("MessageAuBureau")
                                  .orderBy("date", descending: true)
                                  .where("idUser", whereIn: [
                                FirebaseAuth.instance.currentUser!.uid
                              ]).snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return SingleChildScrollView(
                                      // color: AppColors.background,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              (snapshot.data! as QuerySnapshot)
                                                  .docs
                                                  .map((e) {
                                            return (Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        "Message au bureau",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Text(
                                                      e["message"],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                        //decoration: TextDecoration.lineThrough
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .black),
                                                        onPressed: (() {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DetailMessage(
                                                                        e.id)),
                                                          );
                                                        }),
                                                        child: Text(
                                                            "Voir les réponses (${e["reponses"].length})")),
                                                    Center(
                                                      child: Text(
                                                        dateCustomformat(
                                                            DateTime.parse(e[
                                                                    "date"]
                                                                .toDate()
                                                                .toString())),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.blue,
                                                          //decoration: TextDecoration.lineThrough
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            ));
                                          }).toList()));
                                }
                                return Container(
                                  child: Text("Loading"),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                  child: Icon(Icons.edit),
                ),
              )
            ])));
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        });
  }

  Widget headerChild(String header, String value) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(header),
          new SizedBox(
            height: 8.0,
          ),
          new Text(
            '$value',
            style: new TextStyle(
                fontSize: 14.0,
                color: const Color(0xFF26CBE6),
                fontWeight: FontWeight.bold),
          )
        ],
      ));

  Widget infoChild(double width, IconData icon, data) => new Padding(
        padding: new EdgeInsets.only(bottom: 8.0),
        child: new InkWell(
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: width / 10,
              ),
              new Icon(
                icon,
                color: const Color(0xFF26CBE6),
                size: 36.0,
              ),
              new SizedBox(
                width: width / 20,
              ),
              new Text(data)
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
