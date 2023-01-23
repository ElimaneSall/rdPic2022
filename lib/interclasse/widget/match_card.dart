import 'package:flutter/material.dart';
import 'package:tuto_firebase/interclasse/model/match.dart';
import 'package:tuto_firebase/interclasse/screen/detail_match.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MatchCard extends StatelessWidget {
  final Matches match;
  Function function;
  MatchCard(this.match, this.function);
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("fr");
    return InkWell(
        onTap: () {
          function();
        },
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "equipe1.png",
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.height * 0.03,
                        ),
                        SizedBox(
                          width: 200,
                        ),
                        Image.asset(
                          "equipe2.png",
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.height * 0.03,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          match.equipe1,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            //decoration: TextDecoration.lineThrough
                          ),
                        ),
                        SizedBox(
                          width: 200,
                        ),
                        Text(
                          match.equipe2,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            //decoration: TextDecoration.lineThrough
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          match.score1.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            //decoration: TextDecoration.lineThrough
                          ),
                        ),
                        SizedBox(
                          width: 115,
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 115,
                        ),
                        Text(
                          match.score2.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            //decoration: TextDecoration.lineThrough
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Center(
                        child: Text(
                      dateCustomformat(
                          DateTime.parse(match.date.toDate().toString())),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ))
                  ],
                ))));
  }
}
