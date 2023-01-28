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
  static Color primary = Color.fromRGBO(91, 60, 30, 1);
  static Color secondary = Colors.black;
  static Color tertiare = Color.fromRGBO(43, 43, 61, 1);
  static Color red = Color.fromRGBO(255, 0, 0, 0.58);
  static Color background = Color.fromRGBO(217, 217, 217, 0.36);
  static Color softBlue = const Color.fromARGB(255, 37, 76, 95);
  static Color blue = Color.fromRGBO(31, 86, 221, 1);
  static Color lightGray = Color.fromRGBO(0, 0, 0, 0.12);
}
