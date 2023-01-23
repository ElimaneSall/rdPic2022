import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';
import 'package:tuto_firebase/homeApp.dart';
import 'package:tuto_firebase/login/signIn.dart';
import 'package:tuto_firebase/screen/homeScreen.dart';
import 'package:tuto_firebase/tuto/addUser.dart';
import 'package:tuto_firebase/tuto/add_data.dart';
import 'package:tuto_firebase/tuto/liste_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, theme: ThemeData(), home: SignIn());
  }
}
