import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Primary palette – "Warm Organic / Cultural"
  static const Color crimson = Color(0xFF8B0000); // Crimson - #8B0000
  static const Color gold = Color(0xFFD4AF37); // Gold - #D4AF37
  static const Color parchment = Color(0xFFF4EBD0); // Parchment - #F4EBD0
  static const Color wood = Color(0xFF4B2E1E); // Wood - #4B2E1E

  // Compatibility names (if used elsewhere)
  static const Color primary = crimson;
  static const Color accent = gold;
  static const Color background = parchment;
  static const Color surface = Colors.white;

  // Text colors
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF6D4C41);
  static const Color textOnPrimary = Colors.white;

  // Tree node colors
  static const Color nodeMale = Color(0xFFE8F1F8); // Sang trọng hơn xanh nhạt
  static const Color nodeFemale = Color(0xFFF9E8EE); // Sang trọng hơn hồng nhạt
  static const Color nodeDeceased = Color(0xFFCFD8DC);
  static const Color nodeBorder = gold;
  static const Color connectionLine = wood;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.crimson,
        primary: AppColors.crimson,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
      ),
      scaffoldBackgroundColor: AppColors.parchment,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.wood,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.crimson,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.gold.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.crimson,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.crimson,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
    return baseTheme;
  }
}






