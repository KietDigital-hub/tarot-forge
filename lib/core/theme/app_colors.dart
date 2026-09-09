import 'package:flutter/material.dart';

/// Mystical color palette tailored for Tarot Forge:
/// Deep arcane purples and luminous antique golds for Dark Mode;
/// Antiqued parchment, gilded bronze, and deep sepia ink for Light Mode.
class AppColors {
  AppColors._();

  // --- Dark Mystical Palette (Default) ---
  static const Color darkBackground = Color(0xFF10081C);
  static const Color darkSurface = Color(0xFF1B0F2E);
  static const Color darkSurfaceVariant = Color(0xFF271740);
  static const Color darkCardBackground = Color(0xFF1A1227);

  // Antique Gold accents
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldBright = Color(0xFFF7E298);
  static const Color goldDark = Color(0xFF9E7E24);
  static const Color goldMuted = Color(0x66D4AF37);
  static const Color goldGazeAura = Color(0x33D4AF37);

  // Mystic Accents
  static const Color astralCyan = Color(0xFF7CA7C7);
  static const Color velvetPlum = Color(0xFF4A1838);
  static const Color crimsonSeal = Color(0xFF8A1C2C);

  // Dark Text
  static const Color darkTextPrimary = Color(0xFFFBF8F2);
  static const Color darkTextSecondary = Color(0xFFB8A6CC);
  static const Color darkTextMuted = Color(0xFF7F6F94);

  // --- Light Parchment Palette ---
  static const Color lightBackground = Color(0xFFF6F2E9);
  static const Color lightSurface = Color(0xFFECE4D0);
  static const Color lightSurfaceVariant = Color(0xFFE2D6BE);
  static const Color lightCardBackground = Color(0xFFFAF7F0);

  // Gilded Bronze / Dark Gold for Light Mode
  static const Color lightGoldPrimary = Color(0xFFB0821A);
  static const Color lightGoldBright = Color(0xFFCF9D2A);
  static const Color lightGoldDark = Color(0xFF7A590C);

  // Light Text
  static const Color lightTextPrimary = Color(0xFF261D16);
  static const Color lightTextSecondary = Color(0xFF635647);
  static const Color lightTextMuted = Color(0xFF948574);

  // Linear Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldBright, goldPrimary, goldDark, goldPrimary],
    stops: [0.0, 0.4, 0.8, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF221538), Color(0xFF140D24)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [Color(0xFFFFFDF8), Color(0xFFEFE9DB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
