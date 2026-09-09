import '../constants/tarot_constants.dart';

/// Accurate mathematical unit conversions for physical print output.
class UnitConverter {
  UnitConverter._();

  /// Converts millimeters to PDF points (1 in = 25.4 mm = 72 pt).
  static double mmToPt(double mm) {
    return mm * TarotConstants.pointsPerMm;
  }

  /// Converts PDF points to millimeters.
  static double ptToMm(double pt) {
    return pt / TarotConstants.pointsPerMm;
  }

  /// Converts millimeters to raster pixels at target DPI (default 300 DPI).
  static int mmToPx(double mm, [int dpi = TarotConstants.printDpi]) {
    return ((mm / 25.4) * dpi).round();
  }

  /// Converts pixels at target DPI back to millimeters.
  static double pxToMm(int px, [int dpi = TarotConstants.printDpi]) {
    return (px / dpi) * 25.4;
  }
}
