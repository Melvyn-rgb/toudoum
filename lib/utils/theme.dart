import 'package:flutter/material.dart';

const mainColor = Color(0x000000); // Netflix Red

final ThemeData appTheme = ThemeData(
  fontFamily: 'Netflix Sans, Helvetica Neue, Segoe UI, Roboto, Ubuntu, sans-serif',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: mainColor,
    secondary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ), // Use for large headers
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    ), // Use for general text
  ),
);