import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/MessageAuBureau/model/MessageAuBureauModel.dart';
import 'package:tuto_firebase/MessageAuBureau/widget/DetailMessage.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class MessageAuBureauCard extends StatelessWidget {
  MessageAuBureauModel _messageAuBureauModel;
  MessageAuBureauCard(this._messageAuBureauModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.background, borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Text(
            "Message au bureau",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          _messageAuBureauModel.message,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            //decoration: TextDecoration.lineThrough
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.black),
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailMessage(_messageAuBureauModel.id)),
              );
            }),
            child: Text(
                "Voir les réponses (${_messageAuBureauModel.reponses.length})")),
        Center(
          child: Text(
            dateCustomformat(
                DateTime.parse(_messageAuBureauModel.date.toDate().toString())),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              //decoration: TextDecoration.lineThrough
            ),
          ),
        )
      ]),
    );
  }
}
