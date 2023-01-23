import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/annonce/model/evenement.dart';

import 'package:tuto_firebase/annonce/screen/detailEvenement.dart';

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
                      evenement.image,
                      evenement.auteur,
                      evenement.id,
                      evenement.likes,
                      evenement.commentaires)));
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: Colors.blue,
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              width: 130,
                              height: 110,
                              child: Image.network(
                                evenement.image,
                                fit: BoxFit.cover,
                              ))),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: evenement.status == "urgent"
                                        ? Colors.red
                                        : Colors.green),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                evenement.titre,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  //decoration: TextDecoration.lineThrough
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            evenement.auteur,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              //decoration: TextDecoration.lineThrough
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            evenement.poste,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            evenement.date.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
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
