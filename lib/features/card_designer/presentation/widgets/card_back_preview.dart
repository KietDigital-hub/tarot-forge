import 'package:flutter/material.dart';
import '../../../../core/constants/tarot_constants.dart';
import '../../../../core/widgets/card_back_painter.dart';
import '../../domain/models/card_back_design.dart';

/// Widget rendering the Tarot card back with exact Rider-Waite (70:120) proportions,
/// metallic gold/silver vector reflections, and custom artwork support.
class CardBackPreview extends StatelessWidget {
  final CardBackDesign design;
  final bool isDark;
  final bool showShadow;

  const CardBackPreview({
    super.key,
    required this.design,
    required this.isDark,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: TarotConstants.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.65 : 0.25),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: design.foilColor.withValues(alpha: isDark ? 0.22 : 0.12),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Solid or Custom Art Base
              if (design.hasCustomImage)
                Image.memory(
                  design.customImageBytes!,
                  fit: BoxFit.cover,
                )
              else
                Container(color: design.backgroundColor),

              // 2. Vector Sacred Pattern Overlay
              if (!design.hasCustomImage || design.pattern != CardBackPattern.customArt)
                CustomPaint(
                  painter: CardBackPainter(
                    pattern: design.pattern,
                    foilColor: design.foilColor,
                    secondaryFoilColor: design.secondaryFoilColor,
                    backgroundColor: design.hasCustomImage
                        ? Colors.transparent
                        : design.backgroundColor,
                  ),
                ),

              // 3. Subtle Metallic Shimmer Edge
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: design.foilColor.withValues(alpha: 0.4),
                    width: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
