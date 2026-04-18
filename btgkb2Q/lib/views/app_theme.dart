import 'package:flutter/material.dart';

/// Giao diện giản lược, tông tối, accent công nghệ (cyan / slate).
abstract class AppTheme {
  static const Color _bg = Color(0xFF0B1220);
  static const Color _surface = Color(0xFF111827);
  static const Color _border = Color(0xFF1F2937);
  static const Color _accent = Color(0xFF22D3EE);
  static const Color _muted = Color(0xFF94A3B8);

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
    );
    return base.copyWith(
      scaffoldBackgroundColor: _bg,
      colorScheme: const ColorScheme.dark(
        surface: _surface,
        primary: _accent,
        onPrimary: Color(0xFF0B1220),
        secondary: _muted,
        onSurface: Color(0xFFE2E8F0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Color(0xFFF1F5F9),
        ),
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: _border),
      listTileTheme: const ListTileThemeData(
        iconColor: _accent,
        textColor: Color(0xFFE2E8F0),
      ),
    );
  }
}
