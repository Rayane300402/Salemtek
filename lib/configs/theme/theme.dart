import 'package:flutter/material.dart';
import 'palette.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',

    // scaffold color unless stated otherwise
    scaffoldBackgroundColor: Palette.surfaceApp,

    // text unless stated otherwise
    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: Palette.text,
      displayColor: Palette.text,
    ),

    // ElevatedButton default style
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.button,
        foregroundColor: Palette.secondary, // text/icon color
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999), // pill/capsule
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}