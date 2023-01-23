import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc("TmdN4QcagleZJH0Vhq3cvC7o6hi2")
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> dataUser =
                snapshot.data!.data() as Map<String, dynamic>;
            return (Container(
              child: new Stack(
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                        gradient: new LinearGradient(colors: [
                      const Color(0xFF26CBE6),
                      const Color(0xFF26CBC0),
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
                                    backgroundImage: new NetworkImage(
                                        dataUser["urlProfile"]),
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
                            child: new Column(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          headerChild('Photos', 114),
                                          headerChild('Followers', 1205),
                                          headerChild('Following', 360),
                                        ]),
                                  ),
                                ),
                                new Padding(
                                  padding:
                                      new EdgeInsets.only(top: _height / 20),
                                  child: new Column(
                                    children: <Widget>[
                                      infoChild(_width, Icons.email,
                                          'zulfiqar108@gmail.com'),
                                      infoChild(
                                          _width, Icons.call, '+12-1234567890'),
                                      infoChild(_width, Icons.group_add,
                                          'Add to group'),
                                      infoChild(_width, Icons.chat_bubble,
                                          'Show all comments'),
                                      new Padding(
                                        padding: new EdgeInsets.only(
                                            top: _height / 30),
                                        child: new Container(
                                          width: _width / 3,
                                          height: _height / 20,
                                          decoration: new BoxDecoration(
                                              color: const Color(0xFF26CBE6),
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      new Radius.circular(
                                                          _height / 40)),
                                              boxShadow: [
                                                new BoxShadow(
                                                    color: Colors.black87,
                                                    blurRadius: 2.0,
                                                    offset:
                                                        new Offset(0.0, 1.0))
                                              ]),
                                          child: new Center(
                                            child: new Text('FOLLOW ME',
                                                style: new TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
          }
          return CircularProgressIndicator();
        });
  }

  Widget headerChild(String header, int value) => new Expanded(
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
