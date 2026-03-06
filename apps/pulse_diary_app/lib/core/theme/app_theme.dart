import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                height: 1.5,
              ),
            ),
      );
}
