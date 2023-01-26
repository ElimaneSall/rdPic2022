import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto_firebase/notifications/model/notifications.dart';
import 'package:tuto_firebase/notifications/widgets/notification_tile.dart';
import 'package:tuto_firebase/utils/color/color.dart';

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
    _retrieveNotifications().then((value) {
      setState(() {
        _notifs = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Notifications",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25)),
            centerTitle: true,
            backgroundColor: AppColors.primary,
            leading: Builder(builder: (context) {
              return IconButton(
                icon:
                    const Icon(Icons.arrow_back, size: 30, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              );
            })),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: StatefulBuilder(builder: ((context, setState) {
              if (_notifs.isNotEmpty) {
                return ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _notifs.length,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          height: 80,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          child: Material(
                              elevation: 8.0,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15.0)),
                              child: ListTile(
                                  tileColor: AppColors.primary,
                                  title: Text(
                                    _notifs[index].title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  subtitle: Text(_notifs[index].body,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13.0)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 25, color: Colors.white),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Notifs')
                                          .doc(_notifs[index].uid)
                                          .set({
                                        ..._notifs[index].toMap(),
                                        'isActive': false
                                      });
                                      _retrieveNotifications().then((value) {
                                        setState(() {
                                          _notifs = value;
                                        });
                                      });
                                    },
                                  ))));
                    });
              } else {
                return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: 80,
                        width: 300,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            child: const Text('Aucune Notification',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))));
              }
            }))));
  }

  Future<List<dynamic>> _retrieveNotifications() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection("Notifs");
      QuerySnapshot snapshot = await collectionRef
          .where('userId', isEqualTo: user!.uid)
          .where('isActive', isEqualTo: true)
          .get();
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
