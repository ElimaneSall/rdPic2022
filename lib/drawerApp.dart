import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/MessageAuBureau/screen/EcrireMessageAuBureau.dart';
import 'package:tuto_firebase/SOSEPT/screen/HomeSOS.dart';
import 'package:tuto_firebase/annonce/screen/homeAnnonce.dart';
import 'package:tuto_firebase/blog/screen/homeArticle.dart';
import 'package:tuto_firebase/interclasse/home/homeInterClasse.dart';
import 'package:tuto_firebase/interclasse/football/screen/homeFootball.dart';
import 'package:tuto_firebase/jeux/screen/Home.dart';
import 'package:tuto_firebase/login/DownloadFile.dart';
import 'package:tuto_firebase/login/GetFile.dart';
import 'package:tuto_firebase/login/QRCode.dart';
import 'package:tuto_firebase/login/SaveFile.dart';
import 'package:tuto_firebase/login/TestNotification2.dart';
import 'package:tuto_firebase/login/profile.dart';
import 'package:tuto_firebase/login/signIn.dart';
import 'package:tuto_firebase/notifications/notifications_page.dart';
import 'package:tuto_firebase/pShop/screen/HomeUserPshop.dart';
import 'package:provider/provider.dart';
import 'blog/screen/ArticleParCategorie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
          accountName: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          accountEmail: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/logoBDE.jpg",
                  ),
                  fit: BoxFit.cover))),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text(
            "Profil",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          }),
      ListTile(
          leading: Icon(Icons.notifications),
          title: const Text(
            "Notifications",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text(
            "Polytech Info",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeAnnonce()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Blog"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeArticle()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Interclasse"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeInterClasse()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("SOS EPT"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeSOS()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("PShop"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeUserPshop()));
            //Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => RD(categorie)),
            // );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Jeux"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChessGame()),
            );
          }),
      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Message au Bureau"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EcrireMessageAuBureau()
                  // DownloadFile()
                  ),
            );
          }),
      // ListTile(
      //     leading: Icon(Icons.favorite),
      //     title: Text("Story 1"),
      //     onTap: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => SplashScreen(

      //                 // DownloadFile()
      //                 ),
      //           ));
      //     }),
      // ListTile(
      //     leading: Icon(Icons.favorite),
      //     title: Text("Story 2"),
      //     onTap: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => MoreStories(

      //                 // DownloadFile()
      //                 ),
      //           ));
      //     }),

      ListTile(
          leading: Icon(Icons.favorite),
          title: Text("Deconnecter"),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');
              print("Deconnecter");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            });
          }),
    ]));
  }
}
