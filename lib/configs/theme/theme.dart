import 'package:flutter/material.dart';
import 'palette.dart';

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Palette.primary),
    );

    // Force Poppins onto *every* text style in the theme.
    final poppinsTextTheme = base.textTheme.apply(
      fontFamily: 'Poppins',
      bodyColor: Palette.text,
      displayColor: Palette.text,
    );

    return base.copyWith(
      scaffoldBackgroundColor: Palette.surfaceApp,
      textTheme: poppinsTextTheme,
      primaryTextTheme: poppinsTextTheme,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.button,
          foregroundColor: Palette.secondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ),
    );
  }
}