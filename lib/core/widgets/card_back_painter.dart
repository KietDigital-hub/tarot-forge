import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../features/card_designer/domain/models/card_back_design.dart';

/// Highly detailed vector CustomPainter for Tarot card backs.
/// Produces 100% rotationally symmetrical occult sacred patterns so that
/// reversed and upright cards cannot be distinguished prior to reveal.
class CardBackPainter extends CustomPainter {
  final CardBackPattern pattern;
  final Color foilColor;
  final Color secondaryFoilColor;
  final Color backgroundColor;

  CardBackPainter({
    required this.pattern,
    required this.foilColor,
    required this.secondaryFoilColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // 1. Base Fill
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. Draw Universal Outer Symmetrical Frames
    _drawOrnateCardBorders(canvas, size);

    // 3. Draw Selected Archetypal Pattern
    switch (pattern) {
      case CardBackPattern.sacredGeometry:
        _drawSacredGeometry(canvas, cx, cy, w, h);
        break;
      case CardBackPattern.celestialCompass:
        _drawCelestialCompass(canvas, cx, cy, w, h);
        break;
      case CardBackPattern.alchemicalOuroboros:
        _drawAlchemicalOuroboros(canvas, cx, cy, w, h);
        break;
      case CardBackPattern.mysticSunMoon:
        _drawMysticSunMoon(canvas, cx, cy, w, h);
        break;
      case CardBackPattern.customArt:
        // Rendered as background image in preview widget, fallback to frame
        _drawCelestialCompass(canvas, cx, cy, w, h);
        break;
    }
  }

  void _drawOrnateCardBorders(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final outerBorderPaint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final innerBorderPaint = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer border margin
    const m1 = 10.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(m1, m1, w - m1 * 2, h - m1 * 2),
        const Radius.circular(8),
      ),
      outerBorderPaint,
    );

    // Inner border margin
    const m2 = 16.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(m2, m2, w - m2 * 2, h - m2 * 2),
        const Radius.circular(5),
      ),
      innerBorderPaint,
    );

    // Micro corner dots and flourishes
    final dotPaint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.fill;

    const dotOffset = 13.0;
    canvas.drawCircle(const Offset(dotOffset, dotOffset), 2.2, dotPaint);
    canvas.drawCircle(Offset(w - dotOffset, dotOffset), 2.2, dotPaint);
    canvas.drawCircle(Offset(dotOffset, h - dotOffset), 2.2, dotPaint);
    canvas.drawCircle(Offset(w - dotOffset, h - dotOffset), 2.2, dotPaint);

    // Symmetrical diamond emblems in the 4 corners
    _drawCornerDiamond(canvas, m2 + 4, m2 + 4);
    _drawCornerDiamond(canvas, w - (m2 + 4), m2 + 4);
    _drawCornerDiamond(canvas, m2 + 4, h - (m2 + 4));
    _drawCornerDiamond(canvas, w - (m2 + 4), h - (m2 + 4));
  }

  void _drawCornerDiamond(Canvas canvas, double x, double y) {
    final paint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const r = 5.0;
    final path = Path()
      ..moveTo(x, y - r)
      ..lineTo(x + r, y)
      ..lineTo(x, y + r)
      ..lineTo(x - r, y)
      ..close();
    canvas.drawPath(path, paint);
  }

  /// Pattern 1: Flower of Life & Sacred Metatron Rings
  void _drawSacredGeometry(Canvas canvas, double cx, double cy, double w, double h) {
    final linePaint = Paint()
      ..color = foilColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final subtlePaint = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final radius = w * 0.28;

    // Central concentric circles
    canvas.drawCircle(Offset(cx, cy), radius, linePaint);
    canvas.drawCircle(Offset(cx, cy), radius * 0.65, subtlePaint);
    canvas.drawCircle(Offset(cx, cy), radius * 1.25, linePaint);

    // 6-Petal Flower of life lattice
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      final px = cx + radius * 0.65 * math.cos(angle);
      final py = cy + radius * 0.65 * math.sin(angle);
      canvas.drawCircle(Offset(px, py), radius * 0.65, subtlePaint);
    }

    // 12 Outer rays / Metatron nodes
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final x1 = cx + (radius * 1.25) * math.cos(angle);
      final y1 = cy + (radius * 1.25) * math.sin(angle);
      final x2 = cx + (radius * 1.55) * math.cos(angle);
      final y2 = cy + (radius * 1.55) * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
    }

    // Top and Bottom Mirror Medallions
    _drawMiniRosette(canvas, cx, cy - h * 0.30, w * 0.12);
    _drawMiniRosette(canvas, cx, cy + h * 0.30, w * 0.12);
  }

  /// Pattern 2: Celestial Compass with 8-Point Star and 4 Crescent Moons
  void _drawCelestialCompass(Canvas canvas, double cx, double cy, double w, double h) {
    final starPaint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fillStarPaint = Paint()
      ..color = foilColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final r = w * 0.30;

    // Rings
    canvas.drawCircle(Offset(cx, cy), r, starPaint);
    canvas.drawCircle(Offset(cx, cy), r * 0.72, accentPaint);
    canvas.drawCircle(Offset(cx, cy), r * 0.25, starPaint);

    // 8-Point Star Path
    final starPath = Path();
    for (int i = 0; i < 16; i++) {
      final angle = (i * 22.5 - 90) * math.pi / 180;
      final currentR = (i % 2 == 0) ? r * 1.2 : r * 0.45;
      final x = cx + currentR * math.cos(angle);
      final y = cy + currentR * math.sin(angle);
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();

    canvas.drawPath(starPath, fillStarPaint);
    canvas.drawPath(starPath, starPaint);

    // 4 Symmetrical Crescent Moons (North, South, East, West)
    _drawCrescentMoon(canvas, cx, cy - r * 0.68, 12, 0);
    _drawCrescentMoon(canvas, cx, cy + r * 0.68, 12, math.pi);
    _drawCrescentMoon(canvas, cx - r * 0.68, cy, 12, -math.pi / 2);
    _drawCrescentMoon(canvas, cx + r * 0.68, cy, 12, math.pi / 2);

    // Top & Bottom Astrolabe Arcs
    _drawAstrolabeArc(canvas, cx, cy - h * 0.32, w * 0.22, true);
    _drawAstrolabeArc(canvas, cx, cy + h * 0.32, w * 0.22, false);
  }

  /// Pattern 3: Alchemical Ouroboros Seal & Elemental Triangles
  void _drawAlchemicalOuroboros(Canvas canvas, double cx, double cy, double w, double h) {
    final ouroPaint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final glyphPaint = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final r = w * 0.32;

    // Serpent circle (two concentric rings representing body of Ouroboros)
    canvas.drawCircle(Offset(cx, cy), r, ouroPaint);
    canvas.drawCircle(Offset(cx, cy), r - 6, glyphPaint);

    // Scales ticks on ring
    for (int i = 0; i < 36; i++) {
      final angle = (i * 10) * math.pi / 180;
      final x1 = cx + (r - 6) * math.cos(angle);
      final y1 = cy + (r - 6) * math.sin(angle);
      final x2 = cx + r * math.cos(angle);
      final y2 = cy + r * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), glyphPaint);
    }

    // Upward Triangle (Fire) & Downward Triangle (Water) -> Seal of Solomon
    final triR = r * 0.72;
    _drawEquilateralTriangle(canvas, cx, cy, triR, true, glyphPaint);
    _drawEquilateralTriangle(canvas, cx, cy, triR, false, glyphPaint);

    // Central Mercury glyph circle
    canvas.drawCircle(Offset(cx, cy), 8, ouroPaint);
    canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = foilColor);

    // Symmetrical Top and Bottom Triquetra / Alchemy Seals
    _drawAlchemySeal(canvas, cx, cy - h * 0.30, w * 0.15);
    _drawAlchemySeal(canvas, cx, cy + h * 0.30, w * 0.15);
  }

  /// Pattern 4: Mystic Sun & Moon Mirror Symmetry
  void _drawMysticSunMoon(Canvas canvas, double cx, double cy, double w, double h) {
    final goldPaint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final softPaint = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final r = w * 0.22;

    // Central Sun face sphere
    canvas.drawCircle(Offset(cx, cy), r, goldPaint);
    canvas.drawCircle(Offset(cx, cy), r * 0.75, softPaint);

    // 24 Radiant Sun Rays alternating straight and flame
    for (int i = 0; i < 24; i++) {
      final angle = (i * 15) * math.pi / 180;
      final rayLength = (i % 2 == 0) ? r * 1.5 : r * 1.25;
      final x1 = cx + (r + 2) * math.cos(angle);
      final y1 = cy + (r + 2) * math.sin(angle);
      final x2 = cx + rayLength * math.cos(angle);
      final y2 = cy + rayLength * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), goldPaint);
    }

    // Top Moon (facing downward into sun)
    _drawCrescentMoon(canvas, cx, cy - h * 0.28, w * 0.14, 0);
    // Bottom Moon (facing upward into sun)
    _drawCrescentMoon(canvas, cx, cy + h * 0.28, w * 0.14, math.pi);

    // Starlight dots scattered in symmetry
    final starDotPaint = Paint()
      ..color = secondaryFoilColor
      ..style = PaintingStyle.fill;

    for (int dx in [-1, 1]) {
      for (int dy in [-1, 1]) {
        canvas.drawCircle(Offset(cx + dx * w * 0.28, cy + dy * h * 0.18), 2.5, starDotPaint);
        canvas.drawCircle(Offset(cx + dx * w * 0.22, cy + dy * h * 0.38), 2.0, starDotPaint);
      }
    }
  }

  void _drawCrescentMoon(Canvas canvas, double cx, double cy, double radius, double rotation) {
    final moonPaint = Paint()
      ..color = foilColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation);

    final path = Path();
    path.arcTo(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      -math.pi / 2,
      math.pi,
      true,
    );
    path.arcTo(
      Rect.fromCircle(center: Offset(radius * 0.5, 0), radius: radius * 0.85),
      math.pi / 2,
      -math.pi,
      false,
    );
    path.close();

    canvas.drawPath(path, moonPaint);
    canvas.restore();
  }

  void _drawEquilateralTriangle(Canvas canvas, double cx, double cy, double radius, bool pointUp, Paint paint) {
    final path = Path();
    final baseAngle = pointUp ? -math.pi / 2 : math.pi / 2;
    for (int i = 0; i < 3; i++) {
      final angle = baseAngle + (i * 2 * math.pi / 3);
      final x = cx + radius * math.cos(angle);
      final y = cy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawMiniRosette(Canvas canvas, double cx, double cy, double r) {
    final p = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), r, p);
    for (int i = 0; i < 4; i++) {
      final angle = (i * 45) * math.pi / 180;
      canvas.drawLine(
        Offset(cx - r * math.cos(angle), cy - r * math.sin(angle)),
        Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
        p,
      );
    }
  }

  void _drawAstrolabeArc(Canvas canvas, double cx, double cy, double r, bool isTop) {
    final p = Paint()
      ..color = foilColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(rect, isTop ? 0 : math.pi, math.pi, false, p);
  }

  void _drawAlchemySeal(Canvas canvas, double cx, double cy, double r) {
    final p = Paint()
      ..color = secondaryFoilColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), r, p);
    final diamond = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r, cy)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r, cy)
      ..close();
    canvas.drawPath(diamond, p);
  }

  @override
  bool shouldRepaint(covariant CardBackPainter oldDelegate) {
    return oldDelegate.pattern != pattern ||
        oldDelegate.foilColor != foilColor ||
        oldDelegate.secondaryFoilColor != secondaryFoilColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
