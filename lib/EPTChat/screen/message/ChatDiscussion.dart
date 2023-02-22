import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class ChatDiscussion extends StatefulWidget {
  const ChatDiscussion({super.key});

  @override
  State<ChatDiscussion> createState() => _ChatDiscussionState();
}

class _ChatDiscussionState extends State<ChatDiscussion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ELimane Sall",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            Text(
              "@ElimaneSall",
              style:
                  TextStyle(color: Color.fromARGB(93, 0, 0, 0), fontSize: 10),
            ),
          ],
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 5, right: 5, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.background),
                            child: Text("Salut"),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "18h05min",
                            style: TextStyle(fontSize: 7),
                          ),
                        ],
                      )),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, top: 5, right: 5, bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primary),
                            child: Text("Salut"),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "18h05min",
                            style: TextStyle(fontSize: 7),
                          ),
                        ],
                      )),
                ],
              ))),
      floatingActionButton: TextField(
        controller: TextEditingController(),
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        cursorColor: Colors.black,
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        decoration: InputDecoration(
          prefixIcon: (Icon(
            Icons.send,
            color: Colors.black,
          )),
          labelText: "Ecrire un message",
          labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                width: 10, style: BorderStyle.none, color: Colors.black),
          ),
        ),
        keyboardType:
            false ? TextInputType.visiblePassword : TextInputType.emailAddress,
      ),
    );
  }
}
