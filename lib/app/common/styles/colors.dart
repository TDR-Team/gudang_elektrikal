import 'package:flutter/material.dart';

class AppColors {
  static const List<Color> primaryColors = [
    Color(0xFF0E5970),
    Color(0xFF3A97A9),
    Color(0xFF64C9D4),
    Color(0xFF9CEFF0),
    Color(0xFFCCF7F5),
  ];

  static const List<Color> secondaryColors = [
    Color(0xFFFED36A),
    Color(0xFFFACA41),
    Color(0xFFFCDA67),
    Color(0xFFFEEA9A),
    Color(0xFFFEF6CC),
  ];

  static const List<Color> neutralColors = [
    Color(0xFF000000),
    Color(0xFF666666),
    Color(0xFFB2B2B2),
    Color(0xFFE5E5E5),
    Color(0xFFF2F2F2),
  ];
}

ColorScheme kColorScheme = const ColorScheme(
  primary: Color(0xFF125D72),
  // primaryContainer: AppColors.neutralColors[4],
  secondary: Color(0xFFFED36A),
  // secondaryContainer: AppColors.neutralColors[4],
  surface: Colors.white,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
