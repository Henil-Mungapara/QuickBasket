import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double widthFraction(BuildContext context, double fraction) =>
      screenWidth(context) * fraction;

  static double heightFraction(BuildContext context, double fraction) =>
      screenHeight(context) * fraction;
}
