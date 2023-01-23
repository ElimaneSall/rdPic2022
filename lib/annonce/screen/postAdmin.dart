import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class PostAdmin extends StatefulWidget {
  const PostAdmin({Key? key}) : super(key: key);

  @override
  State<PostAdmin> createState() => _PostAdminState();
}

class _PostAdminState extends State<PostAdmin> {
  final titrecontroller = TextEditingController();
  final annoncecontroller = TextEditingController();
  final auteurcontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final postecontroller = TextEditingController();
  final statuscontroller = TextEditingController();


List<String> auteurs = ['Bassirou', 'Fary', 'Aicha'];
String? selectedAuteur = "Bassirou";

List<String> postes = ['Commission Peda', 'Commission Culturelle', 'SG'];
String? selectedPoste = "Commission Peda";

List<String> status = ['Urgent', 'Moins Urgent', 'Facultatif'];
String? selectedStatus = "Urgent";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faire une annonce'),
      ),
       body: Padding(
        padding:  const EdgeInsets.all(10),
        child: 
        Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Auteur:'),
                  SizedBox( width: 200,
                  child:
                    DropdownButton(
      value: selectedAuteur,
     
      items: auteurs
      .map((item) => 
      DropdownMenuItem<String>(
        child: Text(item),
        value: item,)
        ).toList(),
        onChanged: (item)=>setState(() => 
        selectedAuteur = item as String?),
      ))
                  
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Poste:'),
                  SizedBox( width: 200,
                  child:
                    DropdownButton(
      value: selectedPoste,
     
      items: postes
      .map((item) => 
      DropdownMenuItem<String>(
        child: Text(item),
        value: item,)
        ).toList(),
        onChanged: (item)=>setState(() => 
        selectedPoste = item as String?),
      ))
              ]),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Titre:'),
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
                  Text('Annonce:'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: annoncecontroller,
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
                  Text('Status:'),
                   SizedBox( width: 200,
                  child:
                    DropdownButton(
      value: selectedStatus,
     
      items: status
      .map((item) => 
      DropdownMenuItem<String>(
        child: Text(item),
        value: item,)
        ).toList(),
        onChanged: (item)=>setState(() => 
        selectedStatus = item as String?),
      ))
              ]),
            ),
          
            SizedBox(
              height: 20,
            ),

               ElevatedButton(onPressed: 
            (){
              FirebaseFirestore.instance.collection('Annonce').add({
                'titre':titrecontroller.value.text,
                'annonce':annoncecontroller.value.text,
                'auteur':selectedAuteur,
                'date':datecontroller.value.text,
                'poste':selectedPoste,
                'status':selectedStatus,
                'commentaires':[],
                'likes':0,
            });
            Navigator.pop(context);
            }, child: Text('Ajouter')),

       
          ])
          )
          );
  }
}