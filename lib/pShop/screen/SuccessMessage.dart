import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuto_firebase/pShop/screen/HomeUserPshop.dart';
import 'package:tuto_firebase/utils/color/color.dart';

class SuccessMessage extends StatefulWidget {
  const SuccessMessage({Key? key}) : super(key: key);

  @override
  State<SuccessMessage> createState() => _SuccessMessageState();
}

class _SuccessMessageState extends State<SuccessMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("message de succes")),
        backgroundColor: AppColors.primary,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeUserPshop()));
          },
          child: Icon(Icons.arrow_back_ios // add custom icons also
              ),
        ),
      ),
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            color: AppColors.primary, borderRadius: BorderRadius.circular(30)),
        child: Center(
            child: Text(
          "Votre xoss a ete fait avec succes",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        )),
      )),
    );
  }
}
