// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DetailScreen extends StatefulWidget {
  int id;
  String name;
  String image;
   String note;
   bool isPromo;
  
  DetailScreen(this.id, this.image, this.isPromo, this.name, this.note,
    {Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => 
  _DetailScreenState(id, image, isPromo, name, note);
}

class _DetailScreenState extends State<DetailScreen> {
 int _id;
  String _name;
  String _image;
   String _note;
   bool _isPromo;
  _DetailScreenState(this._id,this. _image, this._isPromo, this._name, this._note,);

// launchUrl(String url) async{
//   launch(url);
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              _image,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
           
          ],
        ),
      ),
    );
  }
}