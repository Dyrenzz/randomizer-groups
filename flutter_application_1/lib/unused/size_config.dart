import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockHeight = screenHeight / 100; // Percentage form
    blockWidth = screenWidth / 100; // Percentage form
  }
  static double w(double percentage) => blockWidth * percentage;
  static double h(double percentage) => blockHeight * percentage;
  static double fs(double percentage) => ((blockWidth + blockHeight) / 2) * percentage; // font size by width

}