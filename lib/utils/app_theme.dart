import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const darkTeal = Color(0xFF264653);
  static const teal = Color(0xFF2A9D8F);
  static const darkYellow = Color(0xFFE9C46A);
  static const orange = Color(0xFFe76F51);
  static const lightOrange = Color(0xFFF4A261);
  static const black = Colors.black;
  static const white = Colors.white70;

  static final mainTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: darkTeal,
    ),
    scaffoldBackgroundColor: lightOrange,
    cardColor: white,
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: teal,
      textColor: teal,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(darkTeal),
      )
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkTeal,
    ),
    dialogBackgroundColor: white,
  );
}