
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final yearcontroller = TextEditingController();
  
  final namecontroller  = TextEditingController();
  
  final postercontroller  = TextEditingController();

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un element'),
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
                  Text('Nom'),
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

             ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('Annee'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: yearcontroller,
                  ))
              ]),
            ),
            SizedBox(
              height: 20,
            ),
             ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),
              side:  BorderSide(color: Colors.white)
              ),
              title: Row(children: [
                  Text('poster'),
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    controller: postercontroller,
                  ))
              ]),
            ),
            SizedBox(
              height: 20,
            ),
         
              ElevatedButton(
                child: Text("Add"),
                onPressed: 
            (){
          
              Navigator.pop(context);
           
               FirebaseFirestore.instance.collection('Users').add({
                 'name':namecontroller.value.text,
                'year': yearcontroller.value.text,
                 'poster':postercontroller.value.text,
               // 'categories':categories,
            //     'likes':0
             });})
            // Navigator.pop(context);
            // }, child: Text('Ajouter'))
            
            
            
           ]))
    );;
    
  }
}