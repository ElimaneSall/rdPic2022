import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/SOSEPT/model/SOSModel.dart';
import 'package:tuto_firebase/SOSEPT/model/widget/RepondreSOS.dart';
import 'package:tuto_firebase/SOSEPT/model/widget/SOSCard.dart';
import 'package:tuto_firebase/blog/screen/commentArticlePage.dart';

class DetailSOS extends StatefulWidget {
  String id;
  DetailSOS(this.id);

  @override
  State<DetailSOS> createState() => _DetailSOSState(id);
}

class _DetailSOSState extends State<DetailSOS> {
  String _id;

  _DetailSOSState(this._id);
  void addLikes(String docID, int likes) {
    var newLikes = likes + 1;
    try {
      FirebaseFirestore.instance.collection('SOS').doc(docID).update({
        'likes': newLikes,
      }).then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference xoss = FirebaseFirestore.instance.collection('SOS');
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
                title: Text("Detail SOS"),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(10),
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
                                      MediaQuery.of(context).size.width * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<DocumentSnapshot>(
                                          future:
                                              users.doc(data["idAuteur"]).get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
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
                                                                ],
                                                              ),
                                                              Text("Il y'a 1h")
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
                                        data["sos"],
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
                                  children: [
                                    Text(
                                      "Ri",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            addLikes(_id, data["likes"]);
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                          ),
                                        ),
                                        // SizedBox(height: 10,),
                                        Text(
                                          data["likes"].toString(),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 70,
                                    ),
                                    InkWell(
                                        child: Text(
                                          "Repondre",
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
                                  ],
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Reponses",
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
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: NetworkImage(
                                                          "https://st.depositphotos.com/1011643/2013/i/950/depositphotos_20131045-stock-photo-happy-male-african-university-student.jpg"),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Elimane Sall",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        //   Text(
                                                        //       "Il y'a ${(DateTime.now().toIso8601String())} heures")
                                                      ],
                                                    )
                                                  ],
                                                ),
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
                                                    Text(
                                                      DateTime.parse(
                                                              reponse['date']
                                                                  .toDate()
                                                                  .toString())
                                                          .toString(),
                                                    )
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

        return Text("loading");
      },
    );
  }
}
