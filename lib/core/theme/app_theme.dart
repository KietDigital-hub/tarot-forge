import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Material 3 Themes for Tarot Forge.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.goldPrimary,
        secondary: AppColors.astralCyan,
        surface: AppColors.darkSurface,
        onPrimary: AppColors.darkBackground,
        onSurface: AppColors.darkTextPrimary,
        outline: AppColors.goldMuted,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.goldPrimary),
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 3.0,
          color: AppColors.goldPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 12,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.goldMuted, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldPrimary,
          foregroundColor: AppColors.darkBackground,
          elevation: 6,
          shadowColor: AppColors.goldPrimary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldBright,
          side: const BorderSide(color: AppColors.goldPrimary, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: AppColors.goldMuted, width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.goldPrimary, width: 1),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightGoldPrimary,
        secondary: AppColors.lightGoldBright,
        surface: AppColors.lightSurface,
        onPrimary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        outline: Color(0x66B0821A),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.lightGoldDark),
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 3.0,
          color: AppColors.lightGoldDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 8,
        shadowColor: const Color(0x26000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x66B0821A), width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightGoldPrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.lightGoldPrimary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightGoldDark,
          side: const BorderSide(color: AppColors.lightGoldPrimary, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.cinzel(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: Color(0x44B0821A), width: 1),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightGoldPrimary, width: 1),
        ),
      ),
    );
  }
}
