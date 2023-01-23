import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: controller),
        actions: [
          IconButton(onPressed: (){
            final name = controller.text;
            createUser(name: name);
          }, icon: Icon(Icons.add))
        ],
      ),
    );
  }
  
  Future createUser({required String name}) async {
  
 final docUser = FirebaseFirestore.instance.collection("Users").doc();
 final user = User(
  id:docUser.id,
  name:name,
  age:22,
  birthday:DateTime(2007,01,23)
 );
 final json = user.toJson();
 await docUser.set(json);
  
  } 
}

class User {
  String id;
  final String name;
  final DateTime birthday;
  final int age;

  User({
    this.id ='',
    required this.name,
    required this.age,
    required this.birthday,
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name':name,
    'age':age,
    'birthday':birthday
  };
}