import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6B46C1); // Púrpura moderno
  static const Color secondaryColor = Color(0xFF8B5CF6); // Púrpura claro
  static const Color accentColor = Color(0xFFA78BFA); // Púrpura suave
  static const Color errorColor = Color(0xFFEF4444); // Rojo moderno
  static const Color backgroundColor = Color(0xFFF8FAFC); // Gris muy claro
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF1E293B); // Gris oscuro
  static const Color textSecondaryColor = Color(0xFF64748B); // Gris medio
  static const Color successColor = Color(0xFF10B981); // Verde esmeralda
  static const Color warningColor = Color(0xFFF59E0B); // Amarillo naranja

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textPrimaryColor),
        bodyMedium: TextStyle(fontSize: 14, color: textPrimaryColor),
        bodySmall: TextStyle(fontSize: 12, color: textSecondaryColor),
      ),
    );
  }
}
