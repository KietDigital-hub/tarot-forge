/// Standard dimensional and print-specification constants for Tarot Forge.
/// Based on the standard Rider-Waite Tarot card format (70 x 120 mm).
class TarotConstants {
  TarotConstants._();

  // --- Physical Millimeter Dimensions ---
  /// Trim width in millimeters (finished card width).
  static const double trimWidthMm = 70.0;

  /// Trim height in millimeters (finished card height).
  static const double trimHeightMm = 120.0;

  /// Bleed width in millimeters applied to all 4 edges.
  static const double bleedMm = 3.0;

  /// Full width including 3mm bleed on left and right (76.0 mm).
  static const double fullWidthWithBleedMm = trimWidthMm + (bleedMm * 2);

  /// Full height including 3mm bleed on top and bottom (126.0 mm).
  static const double fullHeightWithBleedMm = trimHeightMm + (bleedMm * 2);

  /// Card aspect ratio: width / height (70 / 120 ≈ 0.5833).
  static const double aspectRatio = trimWidthMm / trimHeightMm;

  // --- Target Print Resolution ---
  /// Industry standard high-resolution print DPI.
  static const int printDpi = 300;

  // --- PDF Points (72 points per inch; 1 mm = 72 / 25.4 pt) ---
  static const double pointsPerMm = 72.0 / 25.4;

  /// Trim width in PDF points (~198.43 pt).
  static const double trimWidthPt = trimWidthMm * pointsPerMm;

  /// Trim height in PDF points (~340.16 pt).
  static const double trimHeightPt = trimHeightMm * pointsPerMm;

  /// Bleed margin in PDF points (~8.50 pt).
  static const double bleedPt = bleedMm * pointsPerMm;

  /// Full width with bleed in PDF points (~215.43 pt).
  static const double fullWidthPt = fullWidthWithBleedMm * pointsPerMm;

  /// Full height with bleed in PDF points (~357.17 pt).
  static const double fullHeightPt = fullHeightWithBleedMm * pointsPerMm;

  // --- 300 DPI Pixel Counts (1 mm = 300 / 25.4 px) ---
  static const double pixelsPerMmAt300Dpi = printDpi / 25.4;

  /// Trim width in pixels at 300 DPI (827 px).
  static const int trimWidthPx300Dpi = 827;

  /// Trim height in pixels at 300 DPI (1417 px).
  static const int trimHeightPx300Dpi = 1417;

  /// Full width with bleed in pixels at 300 DPI (898 px).
  static const int fullWidthPx300Dpi = 898;

  /// Full height with bleed in pixels at 300 DPI (1488 px).
  static const int fullHeightPx300Dpi = 1488;
}
