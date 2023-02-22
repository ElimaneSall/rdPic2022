import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/MasterHome.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/login/TestNotification2.dart';
import 'package:tuto_firebase/login/UploadFile.dart';
import 'package:tuto_firebase/login/signIn.dart';
import 'package:tuto_firebase/screen/homeScreen.dart';

// import 'package:camera/camera.dart';
// import 'dart:async';
// List<CameraDescription> cameras;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.messageId}");
}

Future<void> main() async {
  //  cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // theme: AppTheme().light,
        // darkTheme: AppTheme().dark,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        title: 'EPTChat',
        // builder: (context, child) {
        //   return StreamChatCore(
        //     client: client,
        //     child: child!,
        //   );
        // },
        home: MasterHome());
  }
}
