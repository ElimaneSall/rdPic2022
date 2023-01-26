import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/annonce.dart';

import 'package:tuto_firebase/annonce/screen/detailEvenement.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class AnnonceCard extends StatelessWidget {
  final Annonce annonce;
  AnnonceCard(this.annonce);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: InkWell(
                // onTap: () {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => DetailAnnonce(
                //               annonce.annonce,
                //               annonce.auteur,
                //               annonce.id,
                //               annonce.likes,
                //               annonce.commentaires,
                //               annonce.date)));
                // },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        "https://st.depositphotos.com/1011643/2013/i/950/depositphotos_20131045-stock-photo-happy-male-african-university-student.jpg"),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Elimane Sall",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        timeAgoCustom(DateTime.parse(
                                            annonce.date.toDate().toString())),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
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
                              annonce.status == "urgent"
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
                                      child: Center(child: Text("Urgent")),
                                    )
                                  : Container()
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        //  addLikes(_id, 1);
                                      },
                                      icon: Icon(Icons.favorite)),
                                  // SizedBox(height: 10,),
                                  Text(1.toString()),
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
                ])))));
  }
}
