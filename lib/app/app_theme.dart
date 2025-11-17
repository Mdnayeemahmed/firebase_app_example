import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF8866FF),
    scaffoldBackgroundColor: const Color(0xFFF6F9F9),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF6F9F9),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF0C1D2E)),
      titleTextStyle: TextStyle(
        color: Color(0xFF0C1D2E),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      elevation: 2,
      color: Color(0xFFFFFFFF),
      shadowColor: Color(0x1A000000),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Color(0xFF0C1D2E)),
      headlineMedium: TextStyle(color: Color(0xFF0C1D2E)),
      headlineSmall: TextStyle(color: Color(0xFF0C1D2E)),
      bodyLarge: TextStyle(color: Color(0xFF0C1D2E)),
      bodyMedium: TextStyle(color: Color(0xFF748BA0)),
      bodySmall: TextStyle(color: Color(0xFF9CA3AF)),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: Color(0xFF0C1D2E)),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8866FF),
        foregroundColor: Colors.white,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFFFFFFFF),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8866FF), width: 2),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E7EB),
      thickness: 1,
    ),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF8866FF),
      secondary: Color(0xFFFFCA40),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFEF4444),
    ),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF8866FF),
    scaffoldBackgroundColor: const Color(0xFF121212),

    // App Bar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFE5E7EB)),
      titleTextStyle: TextStyle(
        color: Color(0xFFE5E7EB),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      elevation: 2,
      color: Color(0xFF2D2D2D),
      shadowColor: Color(0x40000000),
    ),

    // Text Theme
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Color(0xFFE5E7EB)),
      headlineMedium: TextStyle(color: Color(0xFFE5E7EB)),
      headlineSmall: TextStyle(color: Color(0xFFE5E7EB)),
      bodyLarge: TextStyle(color: Color(0xFFE5E7EB)),
      bodyMedium: TextStyle(color: Color(0xFF9CA3AF)),
      bodySmall: TextStyle(color: Color(0xFF6B7280)),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: Color(0xFFE5E7EB)),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8866FF),
        foregroundColor: Colors.white,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF1F1F1F),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF374151)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF374151)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8866FF), width: 2),
      ),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF374151),
      thickness: 1,
    ),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8866FF),
      secondary: Color(0xFFFFCA40),
      surface: Color(0xFF1E1E1E),
      error: Color(0xFFEF4444),
    ),
  );
}