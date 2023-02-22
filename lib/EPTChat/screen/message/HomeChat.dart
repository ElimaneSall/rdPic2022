import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuto_firebase/EPTChat/screen/message/ListUser.dart';
import 'package:tuto_firebase/EPTChat/screen/message/ChatPage.dart';
import 'package:tuto_firebase/EPTChat/twitter/homeTwitter.dart';
import 'package:tuto_firebase/utils/method.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body:
          // backgroundColor: Colors.indigo,

          SafeArea(
        child: Column(
          children: [
            _top(),
            _body(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(
            Icons.contact_page,
          ),
          onPressed: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListUser(),
                ));
          })),
    );
  }

  Widget _top() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FirebaseAuth.instance.currentUser!.uid),
          Text(
            'EPT Chat,  \nReseau Social des Polytech ',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.black12,
                ),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                "https://www.seekpng.com/png/detail/46-463314_v-th-h-user-profile-icon.png"),
                          ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    var _user1 = "";
    // var _user2 = "";

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            // border: Border(bottom: BorderSide(width: 5)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            color: Colors.white),
        child: ListView(
          padding: EdgeInsets.only(top: 5),
          physics: BouncingScrollPhysics(),
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Chat")
                    .orderBy("date", descending: true)
                    .where(
                      "idUsers",
                      arrayContains: FirebaseAuth.instance.currentUser!.uid,
                    )
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                        // color: AppColors.background,
                        child: Column(
                      children: (snapshot.data! as QuerySnapshot)
                          .docs
                          .map((e) => _itemChats(data: e.data(), id: e.id))
                          .toList(),
                    ));
                  }
                  return Center(
                    child: Text("Loading"),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _itemChats({
    required var data,
    required String id,
  }) {
    var lastMessage = data["discussions"][data["discussions"].length - 1];
    var _user1 = "";
    data["idUser1"] != FirebaseAuth.instance.currentUser!.uid
        ? _user1 = data["idUser1"]
        : _user1 = data["idUser2"];
    return Column(
      children: [
        // for (var message in discussions)
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatPage(_user1, id),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            elevation: 0,
            child: Row(
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(_user1)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> dataUser1 =
                            snapshot.data!.data() as Map<String, dynamic>;
                        // role = dataUser["role"];
                        return Container(
                            color: Colors.white,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        dataUser1["urlProfile"],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ));
                      }
                      return Text("");
                    }),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(_user1)
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (snapshot.hasData &&
                                    !snapshot.data!.exists) {
                                  return Text("Document does not exist");
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> dataUser = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  // role = dataUser["role"];
                                  return Container(
                                      color: Colors.white,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              // CircleAvatar(
                                              //   radius: 30,
                                              //   backgroundImage: NetworkImage(
                                              //     dataUser["urlProfile"],
                                              //   ),
                                              // ),
                                              // SizedBox(
                                              //   width: 10,
                                              // ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${dataUser["prenom"]}',
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        dataUser["nom"],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ));
                                }
                                return Text("");
                              }),
                          Text(
                            timeAgoCustom(DateTime.parse(
                                lastMessage["date"].toDate().toString())),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          // margin: EdgeInsets.only(left: 80),
                          // color: Colors.red,
                          child: Text(
                        '${lastMessage["message"]}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  /// update index function to update the index onTap in BottomNavigationBar
  void updateIndex(int index) => emit(index);

  /// for navigation button on single page
  void getHome() => emit(0);
  void getTasks() => emit(1);
  void getApps() => emit(2);
  void getNotification() => emit(3);
  void getProfile() => emit(4);
}

class Avatar extends StatelessWidget {
  final double size;
  final image;
  final EdgeInsets margin;
  Avatar({this.image, this.size = 50, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
