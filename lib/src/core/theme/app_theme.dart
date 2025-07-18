import 'package:flutter/material.dart';

class AppTheme {
  // Apple HIG & Square-inspired color palette
  static const Color _appleBlue = Color(0xFF007AFF);
  static const Color _appleGreen = Color(0xFF34C759);
  static const Color _appleOrange = Color(0xFFFF9500);
  static const Color _appleRed = Color(0xFFFF3B30);
  
  // Light theme colors
  static const Color _lightBackground = Color(0xFFF2F2F7);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE5E5EA);
  static const Color _lightText = Color(0xFF000000);
  static const Color _lightSecondaryText = Color(0xFF8E8E93);
  static const Color _lightTertiaryText = Color(0xFFC7C7CC);
  
  // Dark theme colors
  static const Color _darkBackground = Color(0xFF18191A);
  static const Color _darkCard = Color(0xFF232325);
  static const Color _darkBorder = Color(0xFF2C2C2E);
  static const Color _darkText = Color(0xFFF2F2F7);
  static const Color _darkSecondaryText = Color(0xFFB0B0B0);
  static const Color _darkTertiaryText = Color(0xFF8E8E93);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'SF Pro Display',
      colorScheme: const ColorScheme.light(
        primary: _appleBlue,
        onPrimary: Colors.white,
        secondary: _appleGreen,
        onSecondary: Colors.white,
        tertiary: _appleOrange,
        onTertiary: Colors.white,
        error: _appleRed,
        onError: Colors.white,
        background: _lightBackground,
        onBackground: _lightText,
        surface: _lightCard,
        onSurface: _lightText,
        surfaceVariant: _lightBackground,
        onSurfaceVariant: _lightSecondaryText,
      ),
      scaffoldBackgroundColor: _lightBackground,
      cardColor: _lightCard,
      cardTheme: CardThemeData(
        color: _lightCard,
        elevation: 0, // Apple HIG: flat design
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Apple HIG: 12px radius
          side: const BorderSide(color: _lightBorder, width: 0.5), // Subtle border
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightCard, // Apple HIG: white app bar
        foregroundColor: _lightText, // Apple HIG: dark text
        elevation: 0, // Apple HIG: flat design
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600, // Apple HIG: semibold
          fontSize: 17, // Apple HIG: standard size
          color: _lightText,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _lightText),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _lightText),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _lightText),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _lightText),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _lightText),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _lightText),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _lightText),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _lightText),
        bodyLarge: TextStyle(fontSize: 16, color: _lightText),
        bodyMedium: TextStyle(fontSize: 15, color: _lightText),
        bodySmall: TextStyle(fontSize: 14, color: _lightSecondaryText),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _lightText),
        labelMedium: TextStyle(fontSize: 13, color: _lightSecondaryText),
        labelSmall: TextStyle(fontSize: 12, color: _lightSecondaryText),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: _lightBorder),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _appleBlue, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _appleBlue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 0, // Apple HIG: flat design
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _appleBlue,
          side: const BorderSide(color: _appleBlue),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: _appleBlue,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      dividerColor: _lightBorder,
      iconTheme: const IconThemeData(color: _appleBlue),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'SF Pro Display',
      colorScheme: const ColorScheme.dark(
        primary: _appleBlue,
        onPrimary: Colors.white,
        secondary: _appleGreen,
        onSecondary: Colors.white,
        tertiary: _appleOrange,
        onTertiary: Colors.white,
        error: _appleRed,
        onError: Colors.white,
        background: _darkBackground,
        onBackground: _darkText,
        surface: _darkCard,
        onSurface: _darkText,
        surfaceVariant: _darkBackground,
        onSurfaceVariant: _darkSecondaryText,
      ),
      scaffoldBackgroundColor: _darkBackground,
      cardColor: _darkCard,
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0, // Apple HIG: flat design
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Apple HIG: 12px radius
          side: const BorderSide(color: _darkBorder, width: 0.5), // Subtle border
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkCard, // Apple HIG: dark app bar
        foregroundColor: _darkText, // Apple HIG: light text
        elevation: 0, // Apple HIG: flat design
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600, // Apple HIG: semibold
          fontSize: 17, // Apple HIG: standard size
          color: _darkText,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _darkText),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _darkText),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _darkText),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _darkText),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _darkText),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _darkText),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _darkText),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _darkText),
        bodyLarge: TextStyle(fontSize: 16, color: _darkText),
        bodyMedium: TextStyle(fontSize: 15, color: _darkText),
        bodySmall: TextStyle(fontSize: 14, color: _darkSecondaryText),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _darkText),
        labelMedium: TextStyle(fontSize: 13, color: _darkSecondaryText),
        labelSmall: TextStyle(fontSize: 12, color: _darkSecondaryText),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: _darkBorder),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _appleBlue, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _appleBlue,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 0, // Apple HIG: flat design
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _appleBlue,
          side: const BorderSide(color: _appleBlue),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: _appleBlue,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      dividerColor: _darkBorder,
      iconTheme: const IconThemeData(color: _appleBlue),
      useMaterial3: true,
    );
  }

  /// Apple HIG & Square-inspired button styles
  static final ButtonStyle neutralButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: _lightBackground,
    foregroundColor: _lightText,
    elevation: 0,
    side: const BorderSide(color: _lightBorder),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  );

  /// Status colors for semantic meaning (not backgrounds)
  static const Color successColor = _appleGreen;
  static const Color warningColor = _appleOrange;
  static const Color errorColor = _appleRed;
  static const Color infoColor = _appleBlue;
} 