import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/notifications/model/notifications.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class NotificationTile extends StatelessWidget {
  final CustomNotification notification;
  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        height: 80,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Material(
            elevation: 8.0,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: ListTile(
                tileColor: AppColors.primary,
                title: Text(
                  notification.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                subtitle: Text(notification.body,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 13.0)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 25, color: Colors.white),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Notifs')
                        .doc(notification.uid)
                        .set({...notification.toMap(), 'isActive': false});
                  },
                ))));
  }
}
