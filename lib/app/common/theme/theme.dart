import 'package:flutter/material.dart';
import '../styles/colors.dart';

ThemeData themeData = ThemeData(
  fontFamily: 'Poppins',
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent, 
    backgroundColor: kColorScheme.background,
  ),
  cardTheme: const CardTheme(
    surfaceTintColor: Colors.white,
  ),
);
