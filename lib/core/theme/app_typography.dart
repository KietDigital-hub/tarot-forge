import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Mystical & legible typography system for Tarot Forge.
class AppTypography {
  AppTypography._();

  // --- Display & Card Typography (Cinzel) ---
  static TextStyle cardNumeral({required bool isDark, double fontSize = 16}) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 4.0,
      color: isDark ? AppColors.goldBright : AppColors.lightGoldDark,
    );
  }

  static TextStyle cardTitle({required bool isDark, double fontSize = 18}) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: 3.5,
      color: isDark ? AppColors.goldBright : AppColors.lightGoldDark,
      shadows: isDark
          ? [
              Shadow(
                color: AppColors.goldPrimary.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ]
          : null,
    );
  }

  static TextStyle cardSubtitle({required bool isDark, double fontSize = 11}) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.5,
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
    );
  }

  // --- UI Chrome Typography (Outfit) ---
  static TextStyle screenTitle({required bool isDark}) {
    return GoogleFonts.cinzel(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0,
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  static TextStyle sectionHeader({required bool isDark}) {
    return GoogleFonts.cinzel(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.5,
      color: isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary,
    );
  }

  static TextStyle body({required bool isDark, double fontSize = 14}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
    );
  }

  static TextStyle label({required bool isDark, double fontSize = 12}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  static TextStyle buttonText({required bool isDark}) {
    return GoogleFonts.cinzel(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0,
      color: isDark ? AppColors.darkBackground : Colors.white,
    );
  }
}
