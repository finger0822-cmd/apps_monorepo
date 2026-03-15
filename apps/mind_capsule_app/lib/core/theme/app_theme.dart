import 'package:flutter/material.dart';

/// アプリ全体のテーマ定義
abstract final class AppTheme {
  AppTheme._();

  /// 薄いパープル（AppBar・カード背景など）
  static const Color lightPurple = Color(0xFFE8E0F0);

  /// ライトテーマ（Material3）
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B4E9B),
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        backgroundColor: lightPurple,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
        bodyLarge: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  /// ダークテーマ（オプション）
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9B7EC8),
      brightness: Brightness.dark,
    ),
  );
}
