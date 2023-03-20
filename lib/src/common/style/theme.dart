import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    appBarTheme: const AppBarTheme(
      elevation: 0,
    ),
    useMaterial3: true,
  );
}
