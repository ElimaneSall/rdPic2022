import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toLowerCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

class AppColors {
  static Color primary = Color.fromRGBO(91, 60, 30, 100);
  static Color secondary = Colors.black;
  static Color red = Color.fromRGBO(255, 0, 0, 0.58);
  static Color background = Color.fromRGBO(217, 217, 217, 0.36);
  static Color softBlue = const Color.fromARGB(255, 37, 76, 95);
}
