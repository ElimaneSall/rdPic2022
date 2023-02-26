import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class ClassementMatch extends StatefulWidget {
  const ClassementMatch({Key? key}) : super(key: key);

  @override
  State<ClassementMatch> createState() => _ClassementMatchState();
}

class _ClassementMatchState extends State<ClassementMatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Classement Football"),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        body: Center(
            child: Padding(
          padding: EdgeInsets.fromLTRB(5, 40, 5, 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Equipes")
                        .orderBy('P', descending: false)
                        .snapshots(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Table(
                          defaultColumnWidth: FixedColumnWidth(
                              MediaQuery.of(context).size.width * 0.14),
                          border: TableBorder.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 2),
                          children: [
                            TableRow(children: [
                              Column(children: [
                                Text('#', style: TextStyle(fontSize: 15.0))
                              ]),
                              Column(children: [
                                Text('Equipe', style: TextStyle(fontSize: 15.0))
                              ]),
                              Column(children: [
                                Text('J', style: TextStyle(fontSize: 15.0))
                              ]),
                              Column(children: [
                                Text('G', style: TextStyle(fontSize: 15.0))
                              ]),
                              Column(children: [
                                Text('N', style: TextStyle(fontSize: 15.0))
                              ]),
                              Column(children: [
                                Text('P', style: TextStyle(fontSize: 15.0))
                              ]),
                              Column(children: [
                                Text('Pts', style: TextStyle(fontSize: 15.0))
                              ]),
                            ]),
                            TableRow(children: [
                              Column(children: [Text('1')]),
                              Column(children: [Text('DIC 2')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                            ]),
                            TableRow(children: [
                              Column(children: [Text('1')]),
                              Column(children: [Text('TC2 2')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                            ]),
                            TableRow(children: [
                              Column(children: [Text('1')]),
                              Column(children: [Text('TC1 1')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                            ]),
                            TableRow(children: [
                              Column(children: [Text('1')]),
                              Column(children: [Text('DIC 1')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                            ]),
                            TableRow(children: [
                              Column(children: [Text('1')]),
                              Column(children: [Text('DIC 3')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                              Column(children: [Text('5')]),
                            ]),
                          ],
                        );
                      }
                      return Text("Erreur de chargement");
                    })
              ]),
        )));
  }
}
