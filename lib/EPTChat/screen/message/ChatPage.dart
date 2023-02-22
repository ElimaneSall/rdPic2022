import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/method.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatPage extends StatefulWidget {
  String id;
  String idDoc;
  ChatPage(this.id, this.idDoc);
  @override
  _ChatPageState createState() => _ChatPageState(id, idDoc);
}

class _ChatPageState extends State<ChatPage> {
  var user2;

  String _idDoc;
  String _id;
  _ChatPageState(this._id, this._idDoc);
  bool nouvelleDiscussion = false;
  var chat;
  // late Future<DocumentSnapshot<Map<String, dynamic>>> _userFuture;

  getUser(id) {
    var user = null;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          user2 = documentSnapshot.data();
        });
        print('Document data: ${documentSnapshot.data()}');
        user = documentSnapshot.data();
      } else {
        print('Document does not exist on the database');
      }
    });
    return user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      //  user2 = getUser(_id);
      try {
        print("getuser${getUser(_id)}");
        print("Nom");
        print(user2);
        print("getuser2${getUser(_id)}");
      } catch (e) {
        print(e.toString());
      }
      //  _userFuture = FirebaseFirestore.instance
      //   .collection('Users')
      //   .doc(_id)
      //   .get();

      // print(user2["nom"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");

    return Scaffold(
      // appBar: AppBar(
      //     // title: Text("${user2["prenom"]} ${user2["nom"]}"),
      //     ),
      backgroundColor: Colors.indigo,
      appBar: AppBar(title: Text(_id)),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _topChat(),
                _bodyChat(),
                SizedBox(
                  height: 120,
                )
              ],
            ),
            _formChat(),
          ],
        ),
      ),
    );
  }

  _topChat() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                "${user2["prenom"]} ${user2["nom"]}",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyChat() {
    chat = FirebaseFirestore.instance.collection("Chat").doc(_idDoc).get();
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 25, right: 25, top: 25),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        color: Colors.white,
      ),
      child: ListView(physics: BouncingScrollPhysics(), children: [
        FutureBuilder<DocumentSnapshot>(
            future: chat,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                nouvelleDiscussion = true;

                return Center(child: Text("Démarrer la discussion"));
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> dataChat =
                    snapshot.data!.data() as Map<String, dynamic>;
                // role = dataUser["role"];
                return Container(
                    // color: AppColors.background,
                    child: _itemChat(discussions: dataChat["discussions"]));
              }
              return Center(
                child: Text("Loading"),
              );
            }),
      ]),
    ));
  }

  // 0 = Send
  // 1 = Recieved
  Widget _itemChat({required List discussions}) {
    return Column(
      children: [
        for (var message in discussions)
          Column(
              mainAxisAlignment:
                  message["idSender"] == FirebaseAuth.instance.currentUser!.uid
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: message["idSender"] ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    message["idSender"] !=
                            FirebaseAuth.instance.currentUser!.uid
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                              "https://www.seekpng.com/png/detail/46-463314_v-th-h-user-profile-icon.png",
                            ),
                          )
                        : SizedBox(),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: message["idSender"] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Colors.indigo.shade100
                              : Colors.indigo.shade50,
                          borderRadius: message["idSender"] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                        ),
                        child: Text('${message["message"]}'),
                      ),
                    ),
                  ],
                ),
                // message["idSender"] != FirebaseAuth.instance.currentUser!.uid
                Text(
                  '${timeAgoCustom(DateTime.parse(message["date"].toDate().toString()))}',
                  textAlign: message["idSender"] ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? TextAlign.end
                      : TextAlign.start,
                  style: TextStyle(
                    decorationColor: Colors.red,
                    color: Colors.grey.shade400,
                  ),
                )
                // : SizedBox(),
              ])
      ],
    );
  }

  Widget _formChat() {
    TextEditingController messagecontroller = TextEditingController();
    return Positioned(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 120,
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          color: Colors.white,
          child: TextField(
            controller: messagecontroller,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.indigo),
                  padding: EdgeInsets.all(14),
                  child: GestureDetector(
                    onTap: () {
                      try {
                        if (nouvelleDiscussion) {
                          print("Discussion$nouvelleDiscussion");
                          FirebaseFirestore.instance.collection("Chat").add({
                            'discussions': FieldValue.arrayUnion([
                              {
                                "idSender":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "idRecever": _id,
                                "date": DateTime.now(),
                                "message": messagecontroller.value.text
                              },
                            ]),
                            "idUser1": FirebaseAuth.instance.currentUser!.uid,
                            "idUser2": _id,
                            "date": DateTime.now(),
                            "idUsers": [
                              FirebaseAuth.instance.currentUser!.uid,
                              _id
                            ]
                          });
                          messagecontroller = TextEditingController();
                        } else {
                          print("Discussion2$nouvelleDiscussion");
                          FirebaseFirestore.instance
                              .collection("Chat")
                              .doc(_idDoc)
                              .update({
                            'discussions': FieldValue.arrayUnion([
                              {
                                "idSender":
                                    FirebaseAuth.instance.currentUser!.uid,
                                "idRecever": _id,
                                "date": DateTime.now(),
                                "message": messagecontroller.value.text
                              }
                            ]),
                            "date": DateTime.now()
                          });
                          messagecontroller = TextEditingController();
                        }
                        setState(() {
                          chat = FirebaseFirestore.instance
                              .collection("Chat")
                              .doc(_idDoc)
                              .get();
                        });
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  )),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.all(20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(144, 33, 149, 243)
                    // Colors.blueGrey[50]
                    ),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(144, 33, 149, 243)),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
