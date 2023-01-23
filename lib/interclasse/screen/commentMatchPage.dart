import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CommentMatchPage extends StatefulWidget {
 String id;
CommentMatchPage(this.id, {Key? key}) : super(key: key);

  @override
  State<CommentMatchPage> createState() => _CommentMatchPageState(id);
}

class _CommentMatchPageState extends State<CommentMatchPage> {
  String _id;
   final namecontroller = TextEditingController();



  _CommentMatchPageState(this._id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un commentaire a'),
      ),
       body: Padding(
        padding:  const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Commentaire:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: namecontroller,
                  ))
              ]),
            ),
            SizedBox(
              height: 20,
            ),

               ElevatedButton(onPressed: 
            (){
              FirebaseFirestore.instance.collection('Matchs').doc(_id).update({
                'commentaires':FieldValue.arrayUnion([namecontroller.value.text]),
            });
            Navigator.pop(context);
            }, child: Text('Ajouter'))
          ])
          )
          );
  }
}