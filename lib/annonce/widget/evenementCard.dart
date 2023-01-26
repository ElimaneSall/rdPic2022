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
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGray,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                      MediaQuery.of(context).size.width * 0.4,
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
                                          0.2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(child: Text("Urgent")),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 1,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            evenement.auteur,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              //decoration: TextDecoration.lineThrough
                            ),
                          ),
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
