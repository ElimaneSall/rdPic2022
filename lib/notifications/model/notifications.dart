import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto_firebase/notifications/service/notification_service.dart';

class CustomNotification {
  String uid;
  String title;
  String body;
  DateTime time;
  String userId;
  bool isActive;

  CustomNotification(this.uid, this.title, this.body, this.time, this.userId,
      {this.isActive = true});

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "title": title,
        "body": body,
        "time": time,
        "userId": userId,
        'isActive': isActive
      };

  factory CustomNotification.fromMap(map) {
    return CustomNotification(
        map['uid'], map["title"], map["body"], map["time"], map["userId"],
        isActive: map["isActive"]);
  }

  static addNotification(
      String uid, String title, String body, String userId) async {
    DateTime time = DateTime.now();
    LocalNotificationService service = LocalNotificationService();
    service.initialize();
    CustomNotification notif =
        CustomNotification(uid, title, body, time, userId);
    await FirebaseFirestore.instance
        .collection('Notifs')
        .doc()
        .set(notif.toMap())
        .then((value) {
      service.showNotification(
          id: 0,
          title: 'Notification',
          body: "Vous avez de nouvelles notifications! Ouvrez l'application");
    }).catchError((error) => print(error));
  }
}
