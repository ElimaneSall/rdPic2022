import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListeUser extends StatefulWidget {
  const ListeUser({Key? key}) : super(key: key);

  @override
  State<ListeUser> createState() => _ListeUserState();
}

class _ListeUserState extends State<ListeUser> {
  @override
  Widget build(BuildContext context) {
    final Stream <QuerySnapshot> _movieStream = FirebaseFirestore.instance.collection('Users').snapshots();
    return  StreamBuilder<QuerySnapshot>(
      stream: _movieStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Padding(padding: EdgeInsets.all(10),
            child: Row(children: [
Text(data['name'].toString())
              // SizedBox(
              //   width: 100, 
              //   child: Image.network(data['image']),
              //   ), 
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 8),
                //   child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       data['name'],
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold
                //       ),
                //       ),
                //       Text('Annee de production'),
                //       Text(data['year'].toString()),
                //       Row(
                //         children: [
                //           for(final categorie in data['categories'])
                //             Padding(padding: EdgeInsets.only(right: 3),
                //           child: Chip(
                //             backgroundColor:Colors.lightBlue,
                //             label: Text(categorie)
                //             ,
                //           )
                //             )
                //         ],
                //       ),
                //       Row(children: [
                //         IconButton(onPressed: (){
                //             addLikes(document.id, data['likes']);
                //         }, icon:Icon(Icons.favorite)),
                //         Text(data['likes'].toString())
                      
                //       ],)
                //   ],)
                //   )
                  ]
                  ));                
          }).toList(),
        );
      },
    );
  }
}