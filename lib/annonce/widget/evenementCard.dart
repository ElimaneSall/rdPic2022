import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/evenement.dart';

import 'package:tuto_firebase/annonce/screen/detailEvenement.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class EvenementCard extends StatelessWidget {
  final Evenement evenement;
  EvenementCard(this.evenement);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          if (FirebaseAuth.instance.currentUser!.uid == evenement.idUser) {
            openDialogDelete(context, evenement.id, "Evenement",
                "Message de suppression", "Voulez vous supprimer ce message");
          }
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailEvenement(
                        evenement.id,
                      )));
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGray,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 110,
                              child: Image.network(
                                evenement.image,
                                fit: BoxFit.cover,
                              ))),
                      SizedBox(
                        width: 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(
                                    evenement.titre,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      //decoration: TextDecoration.lineThrough
                                    ),
                                  )),
                              evenement.status == "urgent"
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03,
                                      width: MediaQuery.of(context).size.width *
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
                                  : evenement.status == "moins urgent"
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
                                            "moins urgent",
                                            style:
                                                TextStyle(color: Colors.yellow),
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
                                                  BorderRadius.circular(30)),
                                          child: Center(
                                              child: Text(
                                            "facultatif",
                                            style:
                                                TextStyle(color: Colors.green),
                                          )),
                                        ),
                              SizedBox(
                                width: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(evenement.idUser)
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
                                  Map<String, dynamic> dataUser = snapshot.data!
                                      .data() as Map<String, dynamic>;

                                  return Container(
                                      child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${dataUser["prenom"]} ${dataUser["nom"]}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                      //decoration: TextDecoration.lineThrough
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ));
                                }
                                return Text("");
                              }),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            evenement.poste,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            dateCustomformat(DateTime.parse(
                                evenement.date.toDate().toString())),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          )
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              )
            ]));
  }
}
