import 'package:flutter/material.dart';

class AppColors {
  static const List<Color> primaryColors = [
    Color(0xFF137BA1),
    Color(0xFF189dcd),
    Color(0xFF32b7e7),
    Color(0xFF5fc7ec),
    Color(0xFF8dd7f2),
  ];

  static const List<Color> onPrimaryColors = [
    Color(0xFFf2f2f2),
    Color(0xFF404040),
  ];
  static const List<Color> secondaryColors = [
    Color(0xFFffdf00),
    Color(0xFFffe433),
    Color(0xFFffeb66),
    Color(0xFFffee80),
    Color(0xFFfff199),
  ];

  static const List<Color> onSecondaryColors = [
    Color(0xFFf2f2f2),
    Color(0xFF404040),
    Color(0xFF000000),
  ];

  static const List<Color> neutralColors = [
    Color(0xFF000000),
    Color(0xFF404040),
    Color(0xFF808080),
    Color(0xFFbfbfbf),
    Color(0xFFf2f2f2),
    Color(0xFFffffff),
  ];

  static const Color errorColors = Color(0xFFff0000);
  static const Color successColors = Color(0xFF00b300);
  static const Color warningColors = Color(0xFFffdf00);
}

ColorScheme kColorScheme = ColorScheme(
  primary: AppColors.primaryColors[0],
  secondary: AppColors.secondaryColors[0],
  surface: AppColors.neutralColors[4],
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
