import 'package:flutter/material.dart';
import '../../../../core/constants/tarot_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/ornate_tarot_frame.dart';
import '../../domain/models/card_template.dart';
import '../../domain/models/tarot_card.dart';

/// Renders the visual Tarot Card with authentic Rider-Waite proportions (70:120).
class CardCanvasPreview extends StatelessWidget {
  final TarotCard card;
  final bool isDark;
  final double? width;
  final double? height;
  final bool showShadow;

  const CardCanvasPreview({
    super.key,
    required this.card,
    required this.isDark,
    this.width,
    this.height,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final template = CardTemplate.allTemplates.firstWhere(
      (t) => t.id == card.templateId,
      orElse: () => CardTemplate.allTemplates.first,
    );

    final primaryGold =
        isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final accentGold =
        isDark ? AppColors.goldBright : AppColors.lightGoldBright;

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
                    color: primaryGold.withValues(alpha: isDark ? 0.18 : 0.10),
                    blurRadius: 18,
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
              // 1. Card Base Paper Background
              Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkCardGradient
                      : AppColors.lightCardGradient,
                ),
              ),

              // 2. Artwork Layer
              Positioned.fill(
                child: _buildArtworkLayer(context, template),
              ),

              // 3. Ornate Vector Frame
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: OrnateTarotFramePainter(
                      style: template.frameStyle,
                      primaryGold: primaryGold,
                      accentGold: accentGold,
                      isDark: isDark,
                    ),
                  ),
                ),
              ),

              // 4. Text & Header Overlays
              Positioned.fill(
                child: _buildTextOverlays(context, template),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtworkLayer(BuildContext context, CardTemplate template) {
    Widget imageWidget;
    if (card.customImageBytes != null) {
      imageWidget = Image.memory(
        card.customImageBytes!,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      );
    } else if (card.assetImagePath != null && card.assetImagePath!.isNotEmpty) {
      imageWidget = Image.asset(
        card.assetImagePath!,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      imageWidget = _buildPlaceholder();
    }

    if (template.isFullBleedImage) {
      return imageWidget;
    }

    // Windowed artwork for traditional frames
    return Padding(
      padding: const EdgeInsets.only(
        top: 38.0,
        bottom: 58.0,
        left: 18.0,
        right: 18.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: (isDark ? AppColors.goldDark : AppColors.lightGoldBright)
                  .withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          child: imageWidget,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: isDark ? const Color(0xFF1B1429) : const Color(0xFFE8E0CE),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: (isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary)
              .withValues(alpha: 0.4),
          size: 48,
        ),
      ),
    );
  }

  Widget _buildTextOverlays(BuildContext context, CardTemplate template) {
    switch (template.textPlacement) {
      case TextPlacement.headerAndFooter:
        return Column(
          children: [
            // Top Roman Numeral
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: _buildNumeralBadge(fontSize: 13),
            ),
            const Spacer(),
            // Bottom Name Banner
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
              child: _buildTitleBanner(),
            ),
          ],
        );

      case TextPlacement.floatingBadges:
        return Column(
          children: [
            const Spacer(),
            // Floating badge on bottom of full-bleed art
            Container(
              margin: const EdgeInsets.only(bottom: 16, left: 18, right: 18),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black87 : Colors.white70)
                    .withValues(alpha: isDark ? 0.78 : 0.88),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary,
                  width: 1.2,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 10),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.romanNumeral,
                    style: AppTypography.cardNumeral(isDark: isDark, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle(isDark: isDark, fontSize: 15),
                  ),
                  if (card.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      card.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.cardSubtitle(isDark: isDark, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );

      case TextPlacement.minimalCentered:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text(
                card.romanNumeral,
                style: AppTypography.cardNumeral(isDark: isDark, fontSize: 12),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 14.0, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle(isDark: isDark, fontSize: 14),
                  ),
                  if (card.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      card.subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.cardSubtitle(isDark: isDark, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );

      case TextPlacement.bottomCombined:
        return Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
              child: _buildTitleBanner(),
            ),
          ],
        );
    }
  }

  Widget _buildNumeralBadge({required double fontSize}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: (isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary)
              .withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Text(
        card.romanNumeral,
        style: AppTypography.cardNumeral(isDark: isDark, fontSize: fontSize),
      ),
    );
  }

  Widget _buildTitleBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            card.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.cardTitle(isDark: isDark, fontSize: 14),
          ),
          if (card.subtitle.isNotEmpty) ...[
            const SizedBox(height: 1),
            Text(
              card.subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.cardSubtitle(isDark: isDark, fontSize: 9.5),
            ),
          ],
        ],
      ),
    );
  }
}
