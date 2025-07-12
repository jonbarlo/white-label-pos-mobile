import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const Color primaryColor = Color(0xFF0176d3); // Salesforce/Stripe blue
    const Color backgroundColor = Color(0xFFF3F3F3); // App background
    const Color cardColor = Color(0xFFFFFFFF); // Card/surface
    const Color cardBorderColor = Color(0xFFE5E5E5); // Card border
    const Color successColor = Color(0xFF2e844a); // Green
    const Color warningColor = Color(0xFFfe9339); // Orange
    const Color errorColor = Color(0xFFea001e); // Red
    const Color textColor = Color(0xFF181818); // Main text
    const Color secondaryTextColor = Color(0xFF747474); // Secondary text

    return ThemeData(
      fontFamily: 'SF Pro Display', // Apple HIG/modern look
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        background: backgroundColor,
        surface: cardColor,
        onSurface: textColor,
        error: errorColor,
        onError: Colors.white,
        secondary: primaryColor,
        onSecondary: Colors.white,
        tertiary: warningColor,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorderColor, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: TextStyle(fontSize: 16, color: textColor),
        bodyMedium: TextStyle(fontSize: 15, color: textColor),
        bodySmall: TextStyle(fontSize: 14, color: secondaryTextColor),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
        labelMedium: TextStyle(fontSize: 13, color: secondaryTextColor),
        labelSmall: TextStyle(fontSize: 12, color: secondaryTextColor),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: cardBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      dividerColor: cardBorderColor,
      iconTheme: const IconThemeData(color: primaryColor),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    const Color primaryColor = Color(0xFF0176d3); // Salesforce/Stripe blue (same as light)
    const Color backgroundColor = Color(0xFF121212); // Dark app background
    const Color cardColor = Color(0xFF1E1E1E); // Dark card/surface
    const Color cardBorderColor = Color(0xFF2E2E2E); // Dark card border
    const Color successColor = Color(0xFF2e844a); // Green (same as light)
    const Color warningColor = Color(0xFFfe9339); // Orange (same as light)
    const Color errorColor = Color(0xFFea001e); // Red (same as light)
    const Color textColor = Color(0xFFE0E0E0); // Light text for dark background
    const Color secondaryTextColor = Color(0xFFB0B0B0); // Secondary text for dark background

    return ThemeData(
      fontFamily: 'SF Pro Display', // Apple HIG/modern look
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        background: backgroundColor,
        surface: cardColor,
        onSurface: textColor,
        error: errorColor,
        onError: Colors.white,
        secondary: primaryColor,
        onSecondary: Colors.white,
        tertiary: warningColor,
        onTertiary: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorderColor, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: TextStyle(fontSize: 16, color: textColor),
        bodyMedium: TextStyle(fontSize: 15, color: textColor),
        bodySmall: TextStyle(fontSize: 14, color: secondaryTextColor),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
        labelMedium: TextStyle(fontSize: 13, color: secondaryTextColor),
        labelSmall: TextStyle(fontSize: 12, color: secondaryTextColor),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: cardBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: primaryColor,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 15),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
      dividerColor: cardBorderColor,
      iconTheme: const IconThemeData(color: primaryColor),
      useMaterial3: true,
    );
  }

  /// Standard neutral/secondary button style (Apple/Salesforce/Stripe/Material3 conventions)
  static final ButtonStyle neutralButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFF3F3F3),
    foregroundColor: Color(0xFF181818),
    elevation: 0,
    side: const BorderSide(color: Color(0xFFE5E5E5)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  );
} 