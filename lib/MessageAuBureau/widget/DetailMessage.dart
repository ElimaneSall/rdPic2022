import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/model/SOSModel.dart';
import 'package:tuto_firebase/SOSEPT/widget/RepondreSOS.dart';
import 'package:tuto_firebase/SOSEPT/widget/SOSCard.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class DetailMessage extends StatefulWidget {
  String id;
  DetailMessage(this.id);

  @override
  State<DetailMessage> createState() => _DetailMessageState(id);
}

class _DetailMessageState extends State<DetailMessage> {
  String _id;
  late String role;
  _DetailMessageState(this._id);

  @override
  Widget build(BuildContext context) {
    DocumentReference xoss =
        FirebaseFirestore.instance.collection('MessageAuBureau').doc(_id);
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
      future: xoss.get(),
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
                title: Text("Détail message au bureau"),
                centerTitle: true,
                backgroundColor: AppColors.primary,
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromRGBO(217, 217, 217, 0.36),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(children: [
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.98,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Message Anonyme",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        data["message"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )),
                                ),
                              )
                            ]),
                            Container(
                                padding: EdgeInsets.all(10),
                                height: 40,
                                color: Colors.black,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                addLikes(_id, "MessageAuBureau",
                                                    data["likes"]);
                                                setState(() {
                                                  xoss = FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'MessageAuBureau')
                                                      .doc(_id);
                                                });
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.white,
                                              ),
                                            ),
                                            // SizedBox(height: 10,),
                                            Text(
                                              data["likes"].toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    InkWell(
                                        child: Text(
                                          "Répondre",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RepondreSOS(_id)));
                                        }),
                                    if (FirebaseAuth
                                            .instance.currentUser!.uid ==
                                        data["idAuteur"])
                                      InkWell(
                                          child: Text(
                                            "Supprimer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          onTap: () {
                                            deleteFunction(
                                                _id, "MessageAuBureau");
                                            Navigator.pop(context);
                                          }),
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Réponses",
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: [
                                    for (final reponse in data["reponses"])
                                      Column(children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder<DocumentSnapshot>(
                                                    future: users
                                                        .doc(reponse["idUser"])
                                                        .get(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot>
                                                            snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            "Something went wrong");
                                                      }

                                                      if (snapshot.hasData &&
                                                          !snapshot
                                                              .data!.exists) {
                                                        return Text(
                                                            "Document does not exist");
                                                      }

                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        Map<String, dynamic>
                                                            dataUser = snapshot
                                                                    .data!
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>;
                                                        role = dataUser["role"];
                                                        return Container(
                                                            color: Colors.white,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                        radius:
                                                                            20,
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
                                                                              dataUser["prenom"],
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 3,
                                                                            ),
                                                                            Text(
                                                                              dataUser["nom"],
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(timeAgoCustom(DateTime.parse(reponse['date']
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
                                                    Text(reponse['reponse']),
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
                          ]))));
        }

        return Scaffold(
            appBar: AppBar(
              title: Text("Détail message au bureau"),
              centerTitle: true,
              backgroundColor: AppColors.primary,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }
}
