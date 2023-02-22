import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class ViewStatus extends StatefulWidget {
  String id;
  ViewStatus(this.id, {super.key});

  @override
  State<ViewStatus> createState() => _ViewStatusState(id);
}

class _ViewStatusState extends State<ViewStatus> {
  String _id;
  _ViewStatusState(this._id);
  final storyController = StoryController();
  List<StoryItem> storyList = [];
  void getStatus() {
    FirebaseFirestore.instance.collection('Status').get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          var _con = StoryController();
          if (result.data()["idUser"] == _id) {
            for (var status in result.data()["status"]) {
              if (status["type"] == "Texte") {
                storyList.add(
                  StoryItem.text(
                    title: status["status"],
                    backgroundColor: Colors.blue,
                  ),
                );
              } else if (result.data()["type"] == "Video") {
                storyList.add(
                  StoryItem.pageVideo(status["urlFile"],
                      controller: storyController),
                );
              } else {
                storyList.add(StoryItem.pageImage(
                  url: status["urlFile"],
                  caption: "Still sampling",
                  controller: storyController,
                ));
              }
            }
          }
        });
        print("somme2$storyList");
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("More"),
      // ),
      body: StoryView(
        storyItems: storyList,
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
