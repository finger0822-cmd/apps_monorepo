import 'package:flutter/material.dart';

/// App-wide theme. Dark theme only.
class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0F0F0F);
  static const Color textMain = Color(0xFFEAEAEA);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    colorScheme: const ColorScheme.dark(
      surface: background,
      onSurface: textMain,
    ),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: textMain,
      displayColor: textMain,
    ),
  );

  /// Theme for the launch error screen (bootstrap failure).
  static ThemeData get launchErrorTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF0F0F0F),
      onSurface: Color(0xFFEAEAEA),
      error: Color(0xFFCF6679),
    ),
  );
}
