import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/EPTChat/screen/status/AddStatus.dart';
import 'package:tuto_firebase/EPTChat/screen/status/ViewStatus.dart';
import 'package:tuto_firebase/utils/method.dart';

class HomeStatus extends StatefulWidget {
  const HomeStatus({super.key});

  @override
  State<HomeStatus> createState() => _HomeStatusState();
}

class _HomeStatusState extends State<HomeStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text("Statut"),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
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

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> dataUser2 =
                              snapshot.data!.data() as Map<String, dynamic>;
                          // role = dataUser["role"];
                          return Container(
                            color: Colors.white,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(dataUser2["urlProfile"]),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.only(bottom: 7),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 0.5, color: Colors.grey))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("Status")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                return Column(
                                  children: [
                                    Text(
                                      "Mon Status",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> selfStatusData =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>;
                                // role = dataUser["role"];
                                return GestureDetector(
                                    child: Container(
                                        //  color: Colors.red,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Mon statut",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "${timeAgoCustom(DateTime.parse(selfStatusData["status"][selfStatusData["status"].length - 1]["date"].toDate().toString()))}")
                                          ],
                                        )),
                                    onLongPress: () {
                                      if (FirebaseAuth
                                              .instance.currentUser!.uid ==
                                          selfStatusData["idUser"]) {
                                        openDialogDelete(
                                            context,
                                            selfStatusData["idUser"],
                                            "Status",
                                            "Statut",
                                            "Voulez vous vraiment supprimer ce statut");
                                      }
                                    },
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewStatus(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)));
                                    });
                              }
                              return Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1,
                              ));
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20,
                top: 20,
              ),
              child: Text(
                "Récent statut",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Status").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> dataStatus =
                        document.data()! as Map<String, dynamic>;
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewStatus(dataStatus["idUser"])));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 10),
                          child: Row(
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(dataStatus["idUser"])
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }

                                    if (snapshot.hasData &&
                                        !snapshot.data!.exists) {
                                      return Text("Document does not exist");
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      Map<String, dynamic> dataUser2 =
                                          snapshot.data!.data()
                                              as Map<String, dynamic>;
                                      // role = dataUser["role"];
                                      return Container(
                                        color: Colors.white,
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              dataUser2["urlProfile"]),
                                        ),
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                padding: EdgeInsets.only(bottom: 7),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.grey))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection("Users")
                                            .doc(dataStatus["idUser"])
                                            .get(),
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
                                            Map<String, dynamic> dataUser1 =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            // role = dataUser["role"];
                                            return Container(
                                              color: Colors.white,
                                              child: Text(
                                                "${dataUser1["prenom"]} ${dataUser1["nom"]}",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }),
                                    Text(
                                        " ${timeAgoCustom(DateTime.parse(dataStatus["status"][dataStatus["status"].length - 1]["date"].toDate().toString()))}")
                                  ],
                                ),
                              )
                            ],
                          ),
                        ));
                  }).toList());
                })
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddStatus()));
          },
          child: Icon(Icons.edit),
        ));
  }
}
