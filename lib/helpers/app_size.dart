import 'package:flutter/material.dart';

/// MediaQuery size helpers — use these instead of calling MediaQuery directly.
class AppSize {
  AppSize._();

  /// Full screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Full screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Screen width as a fraction (e.g. 0.5 = half width)
  static double widthFraction(BuildContext context, double fraction) =>
      screenWidth(context) * fraction;

  /// Screen height as a fraction
  static double heightFraction(BuildContext context, double fraction) =>
      screenHeight(context) * fraction;
}
