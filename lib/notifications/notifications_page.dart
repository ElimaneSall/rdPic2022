import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto_firebase/notifications/model/notifications.dart';
import 'package:tuto_firebase/notifications/widgets/notification_tile.dart';
import 'package:tuto_firebase/utils/color/color.dart';
import 'package:tuto_firebase/utils/method.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  // ignore: prefer_typing_uninitialized_variables
  List<dynamic> _notifs = [];

  @override
  void initState() {
    print("Notif1$_notifs");
    _retrieveNotifications().then((value) {
      setState(() {
        _notifs = value;
      });
    });
    print("Notif2$_notifs");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notification",
              style: TextStyle(
                color: Colors.white,
              )),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          // leading: Builder(builder: (context) {
          //   return IconButton(
          //     icon:
          //         const Icon(Icons.arrow_back, size: 30, color: Colors.white),
          //     onPressed: () => Navigator.of(context).pop(),
          //   );
          // }))
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Notifs")
                  .where("idUser",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where("isActive", isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                      child: Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(color: AppColors.lightGray),
                          child: Center(
                            child: Text("Aucune notification"),
                          )));
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                          title: Text(data['title']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['body']),
                              Text(timeAgoCustom(DateTime.parse(
                                      data["time"].toDate().toString()))
                                  .toString()),
                            ],
                          )

                          // trailing: Text(data["time"].toString()),
                          ),
                    );
                  }).toList(),
                );
              },
            )));
  }

  Future<List<dynamic>> _retrieveNotifications() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection("Notifs");
      QuerySnapshot snapshot =
          await collectionRef.where('idUser', isEqualTo: user!.uid).get();
      List<dynamic> result = snapshot.docs.map((doc) {
        Map data = doc.data() as Map;
        return CustomNotification.fromMap(
            {...data, 'time': data["time"].toDate()});
      }).toList();
      return result;
    } catch (error) {
      return [];
    }
  }
}
