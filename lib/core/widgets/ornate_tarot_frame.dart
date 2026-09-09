import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Style identifier for the ornate card templates.
enum TarotFrameStyle {
  classicArcana,
  celestialMystic,
  minimalistAlchemy,
  fullBleedArt,
}

/// Ornate vector frame painter for Tarot cards with crisp vector geometry.
class OrnateTarotFramePainter extends CustomPainter {
  final TarotFrameStyle style;
  final Color primaryGold;
  final Color accentGold;
  final bool isDark;

  OrnateTarotFramePainter({
    required this.style,
    required this.primaryGold,
    required this.accentGold,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (style) {
      case TarotFrameStyle.classicArcana:
        _paintClassicArcana(canvas, size);
        break;
      case TarotFrameStyle.celestialMystic:
        _paintCelestialMystic(canvas, size);
        break;
      case TarotFrameStyle.minimalistAlchemy:
        _paintMinimalistAlchemy(canvas, size);
        break;
      case TarotFrameStyle.fullBleedArt:
        _paintFullBleed(canvas, size);
        break;
    }
  }

  void _paintClassicArcana(Canvas canvas, Size size) {
    final outerPaint = Paint()
      ..color = primaryGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final innerPaint = Paint()
      ..color = accentGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer margin
    const m1 = 8.0;
    final r1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(m1, m1, size.width - m1 * 2, size.height - m1 * 2),
      const Radius.circular(8),
    );
    canvas.drawRRect(r1, outerPaint);

    // Inner margin
    const m2 = 13.0;
    final r2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(m2, m2, size.width - m2 * 2, size.height - m2 * 2),
      const Radius.circular(5),
    );
    canvas.drawRRect(r2, innerPaint);

    // Ornate Victorian corner flourishes (4 corners)
    final cornerFlourishPaint = Paint()
      ..color = primaryGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    _drawCornerFlourish(canvas, cornerFlourishPaint, m2, m2, 1, 1);
    _drawCornerFlourish(canvas, cornerFlourishPaint, size.width - m2, m2, -1, 1);
    _drawCornerFlourish(
      canvas,
      cornerFlourishPaint,
      m2,
      size.height - m2,
      1,
      -1,
    );
    _drawCornerFlourish(
      canvas,
      cornerFlourishPaint,
      size.width - m2,
      size.height - m2,
      -1,
      -1,
    );
  }

  void _drawCornerFlourish(
    Canvas canvas,
    Paint paint,
    double cx,
    double cy,
    double dirX,
    double dirY,
  ) {
    final path = Path();
    path.moveTo(cx + dirX * 4, cy + dirY * 18);
    path.quadraticBezierTo(
      cx + dirX * 4,
      cy + dirY * 4,
      cx + dirX * 18,
      cy + dirY * 4,
    );

    canvas.drawPath(path, paint);

    // Accent dot
    final fillDot = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx + dirX * 10, cy + dirY * 10), 2.0, fillDot);
  }

  void _paintCelestialMystic(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = primaryGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    const m = 10.0;
    final rect = Rect.fromLTWH(m, m, size.width - m * 2, size.height - m * 2);
    canvas.drawRect(rect, borderPaint);

    // Celestial 8-pointed star in each corner
    _drawCelestialStar(canvas, Offset(m, m), 7.0);
    _drawCelestialStar(canvas, Offset(size.width - m, m), 7.0);
    _drawCelestialStar(canvas, Offset(m, size.height - m), 7.0);
    _drawCelestialStar(canvas, Offset(size.width - m, size.height - m), 7.0);

    // Crescent moons at mid edges
    _drawCrescentMoon(canvas, Offset(size.width / 2, m), 4.5, 0);
    _drawCrescentMoon(
      canvas,
      Offset(size.width / 2, size.height - m),
      4.5,
      math.pi,
    );
  }

  void _drawCelestialStar(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = accentGold
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final r = (i % 2 == 0) ? radius : radius * 0.38;
      final x = center.dx + math.cos(angle) * r;
      final y = center.dy + math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCrescentMoon(
    Canvas canvas,
    Offset center,
    double radius,
    double rotation,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final paint = Paint()
      ..color = primaryGold
      ..style = PaintingStyle.fill;

    final moonPath = Path()
      ..addArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        -math.pi / 2,
        math.pi,
      )
      ..arcTo(
        Rect.fromCircle(center: Offset(radius * 0.45, 0), radius: radius * 0.85),
        math.pi / 2,
        -math.pi,
        false,
      );

    canvas.drawPath(moonPath, paint);
    canvas.restore();
  }

  void _paintMinimalistAlchemy(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = primaryGold.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const m = 12.0;
    const cornerLength = 22.0;

    // Minimal corner brackets
    final corners = [
      // Top-Left
      [Offset(m, m + cornerLength), Offset(m, m), Offset(m + cornerLength, m)],
      // Top-Right
      [
        Offset(size.width - m - cornerLength, m),
        Offset(size.width - m, m),
        Offset(size.width - m, m + cornerLength),
      ],
      // Bottom-Left
      [
        Offset(m, size.height - m - cornerLength),
        Offset(m, size.height - m),
        Offset(m + cornerLength, size.height - m),
      ],
      // Bottom-Right
      [
        Offset(size.width - m - cornerLength, size.height - m),
        Offset(size.width - m, size.height - m),
        Offset(size.width - m, size.height - m - cornerLength),
      ],
    ];

    for (final c in corners) {
      final path = Path()
        ..moveTo(c[0].dx, c[0].dy)
        ..lineTo(c[1].dx, c[1].dy)
        ..lineTo(c[2].dx, c[2].dy);
      canvas.drawPath(path, linePaint);
    }

    // Centered fine crosshairs
    final dotPaint = Paint()
      ..color = accentGold
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, m), 2.5, dotPaint);
    canvas.drawCircle(Offset(size.width / 2, size.height - m), 2.5, dotPaint);
  }

  void _paintFullBleed(Canvas canvas, Size size) {
    // Elegant translucent outer bevel border
    final bevelPaint = Paint()
      ..color = primaryGold.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const m = 6.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(m, m, size.width - m * 2, size.height - m * 2),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, bevelPaint);

    // Corner brass rivets
    final rivetPaint = Paint()
      ..color = accentGold
      ..style = PaintingStyle.fill;

    const rOffset = 12.0;
    const rRadius = 2.5;
    canvas.drawCircle(const Offset(rOffset, rOffset), rRadius, rivetPaint);
    canvas.drawCircle(Offset(size.width - rOffset, rOffset), rRadius, rivetPaint);
    canvas.drawCircle(Offset(rOffset, size.height - rOffset), rRadius, rivetPaint);
    canvas.drawCircle(
      Offset(size.width - rOffset, size.height - rOffset),
      rRadius,
      rivetPaint,
    );
  }

  @override
  bool shouldRepaint(covariant OrnateTarotFramePainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.primaryGold != primaryGold ||
        oldDelegate.accentGold != accentGold ||
        oldDelegate.isDark != isDark;
  }
}
