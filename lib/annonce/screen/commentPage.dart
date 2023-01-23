import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CommentPage extends StatefulWidget {
 String id;
CommentPage(this.id, {Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState(id);
}

class _CommentPageState extends State<CommentPage> {
  String _id;
   final namecontroller = TextEditingController();

   void addCommentaire(String docID, String commentaire){
    var newLikes = commentaire ;
    try{
      FirebaseFirestore.instance.collection('Annonce').doc(docID).update({
        'commentaires': newLikes,
      }).then((value) => print("données à jour"));}catch(e){
        print(e.toString());
      }
    }

  _CommentPageState(this._id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un commentaire'),
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
              FirebaseFirestore.instance.collection('Annonce').doc(_id).update({
                'commentaires':FieldValue.arrayUnion([namecontroller.value.text]),
            });
            Navigator.pop(context);
            }, child: Text('Ajouter'))
          ])
          )
          );
  }
}