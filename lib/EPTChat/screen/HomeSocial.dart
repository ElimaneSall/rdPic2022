import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/EPTChat/screen/message/HomeChat.dart';
import 'package:tuto_firebase/EPTChat/screen/status/HomeStatus.dart';
import 'package:tuto_firebase/EPTChat/twitter/homeTwitter.dart';

class HomeSocialNetwork extends StatefulWidget {
  const HomeSocialNetwork({super.key});

  @override
  State<HomeSocialNetwork> createState() => _HomeSocialNetworkState();
}

class _HomeSocialNetworkState extends State<HomeSocialNetwork> {
  List _pageNavigation = [HomeTwitter(), HomeChat(), HomeStatus()];

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo,
      body: _pageNavigation[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: ((int newIndex) {
          setState(() {
            _current = newIndex;
          });
        }),
        items: [
          BottomNavigationBarItem(label: "Acceuil", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "message", icon: Icon(Icons.message)),
          BottomNavigationBarItem(label: "Statut", icon: Icon(Icons.snapchat))
        ],
      ),
      // SafeArea(
      //   child: Column(
      //     children: [
      //       _top(),
      //       _body(),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: _buildBottomNav()
    );
  }
}
