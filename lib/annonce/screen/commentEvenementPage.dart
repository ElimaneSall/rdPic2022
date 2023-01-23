import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CommentEvenementPage extends StatefulWidget {
 String id;
CommentEvenementPage(this.id, {Key? key}) : super(key: key);

  @override
  State<CommentEvenementPage> createState() => _CommentEvenementPageState(id);
}

class _CommentEvenementPageState extends State<CommentEvenementPage> {
  String _id;
   final namecontroller = TextEditingController();

   void addCommentaire(String docID, String commentaire){
    var newLikes = commentaire ;
    try{
      FirebaseFirestore.instance.collection('Evenement').doc(docID).update({
        'commentaires': newLikes,
      }).then((value) => print("données à jour"));}catch(e){
        print(e.toString());
      }
    }

  _CommentEvenementPageState(this._id);
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
              FirebaseFirestore.instance.collection('Evenement').doc(_id).update({
                'commentaires':FieldValue.arrayUnion([namecontroller.value.text]),
            });
            Navigator.pop(context);
            }, child: Text('Ajouter'))
          ])
          )
          );
  }
}