import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({Key? key}) : super(key: key);

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {
  final auteurcontroller = TextEditingController();
  final categoriecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final imagecontroller = TextEditingController();
  final titrecontroller = TextEditingController();
  final urlcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un article'),
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
                  Text('Auteur:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: auteurcontroller,
                  ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('titre:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: titrecontroller,
                  ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Categorie:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: categoriecontroller,
                  ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Image:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: imagecontroller,
                  ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Description:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: descriptioncontroller,
                  ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Date:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: datecontroller,
                  ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('UrlPDF:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: urlcontroller,
                  ))
              ]),
            ),
            SizedBox(
              height: 20,
            ),

               ElevatedButton(onPressed: 
            (){
              FirebaseFirestore.instance.collection('Article').add({
                'auteur':auteurcontroller.value.text,
                'categorie':categoriecontroller.value.text,
                'date':datecontroller.value.text,
                'description': descriptioncontroller.value.text,
                'image':imagecontroller.value.text,
                'titre':titrecontroller.value.text,
                'urlPDF':urlcontroller.value.text,
                'likes':0,
                'commentaires':[]

            });
            Navigator.pop(context);
            }, child: Text('Ajouter'))
          ])
          )
          );
  }
}