import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/EPTChat/model/lesson.dart';
import 'package:tuto_firebase/EPTChat/screen/message/HomeChat.dart';
import 'package:tuto_firebase/EPTChat/screen/message/ChatPage.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromARGB(50, 63, 81, 181),
        title: Text("Contact"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                elevation: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1.0, color: Colors.white24),
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data["urlProfile"]),
                      ),
                    ),
                    title: Text(
                      "${data["prenom"]} ${data["nom"]} ${data["promo"]}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        // Icon(Icons.linear_scale, color: Colors.yellowAccent,),
                        // Text(" Intermediate", style: TextStyle(color: Colors.white),)
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              data["email"],
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(data["id"], document.id),
                          ));
                    },
                  ),
                ),
              );
            }).toList());
            //  ListView.builder(
            //     scrollDirection: Axis.vertical,
            //     shrinkWrap: true,
            //     itemCount: data.length,
            //     itemBuilder: (context, index) {
            //       return
          }),
    );
  }
}
