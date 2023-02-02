import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';

import 'package:tuto_firebase/annonce/screen/detailEvenement.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class AnnonceCard extends StatelessWidget {
  final Annonce annonce;
  Widget _Downloadwidget;
  AnnonceCard(this.annonce, this._Downloadwidget);
  void _delete(String docID) {
    try {
      FirebaseFirestore.instance
          .collection('Annonce')
          .doc(docID)
          .delete()
          .then((value) => print("données à jour"));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
                onLongPress: () {
                  if (FirebaseAuth.instance.currentUser!.uid ==
                      annonce.idUser) {
                    openDialogDelete(
                        context,
                        annonce.id,
                        "Annonce",
                        "Message de suppression",
                        "Voulez vous supprimer ce message");
                    Navigator.pop(context);
                  }
                },
                child: Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Container(
                          decoration: BoxDecoration(
                              color: AppColors.lightGray,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(annonce.idUser)
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
                                          Map<String, dynamic> dataUser =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;

                                          return Container(
                                              child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        dataUser["urlProfile"],
                                                      )),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            dataUser["prenom"],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            dataUser["nom"],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(timeAgoCustom(
                                                          DateTime.parse(annonce
                                                              .date
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
                                  annonce.status == "urgent"
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Center(
                                              child: Text(
                                            "urgent",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                        )
                                      : annonce.status == "moins urgent"
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Center(
                                                  child: Text(
                                                "moins urgent",
                                                style: TextStyle(
                                                    color: Colors.yellow),
                                              )),
                                            )
                                          : Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Center(
                                                  child: Text(
                                                "facultatif",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )),
                                            )
                                ],
                              ),
                              Center(
                                  child: Text(
                                annonce.titre,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                  //decoration: TextDecoration.lineThrough
                                ),
                              )),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  annonce.annonce,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    //decoration: TextDecoration.lineThrough
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              //  Image.network(annonce.urlFile),
                              Text(
                                annonce.poste,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                addLikes(annonce.id, "Annonce",
                                                    annonce.likes);
                                              },
                                              icon: Icon(Icons.thumb_up)),
                                          // SizedBox(height: 10,),
                                          Text(annonce.likes.toString()),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                undLike(annonce.id, "Annonce",
                                                    annonce.unlikes);
                                              },
                                              icon: Icon(Icons.thumb_down)),
                                          // SizedBox(height: 10,),
                                          Text(annonce.unlikes.toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    dateCustomformat(DateTime.parse(
                                        annonce.date.toDate().toString())),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          )),
                    ])))),
        if (annonce.urlFile != "") _Downloadwidget,
      ],
    ));
  }
}
