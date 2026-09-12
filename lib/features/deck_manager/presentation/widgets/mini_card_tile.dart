import 'package:flutter/material.dart';
import '../../../../core/constants/tarot_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../card_designer/domain/models/tarot_card.dart';

/// Miniature card tile displayed in the Deck Manager 78-card grid.
class MiniCardTile extends StatelessWidget {
  final TarotCard card;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;

  const MiniCardTile({
    super.key,
    required this.card,
    required this.isDark,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final isCustomized = card.isCustomized || card.hasCustomImage;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: TarotConstants.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? gold
                  : (isCustomized
                      ? gold.withValues(alpha: 0.6)
                      : (isDark ? Colors.white12 : Colors.black12)),
              width: isSelected ? 2.0 : (isCustomized ? 1.4 : 1.0),
            ),
            boxShadow: [
              if (isSelected || isCustomized)
                BoxShadow(
                  color: gold.withValues(alpha: isSelected ? 0.35 : 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Artwork Thumbnail
                if (card.customImageBytes != null)
                  Image.memory(
                    card.customImageBytes!,
                    fit: BoxFit.cover,
                  )
                else if (card.assetImagePath != null && card.assetImagePath!.isNotEmpty)
                  Image.asset(
                    card.assetImagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(isDark, gold),
                  )
                else
                  _buildPlaceholder(isDark, gold),

                // 2. Dark Vignette Gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        stops: const [0.0, 0.25, 0.65, 1.0],
                      ),
                    ),
                  ),
                ),

                // 3. Top Header: Roman Numeral & Custom Badge
                Positioned(
                  top: 6,
                  left: 6,
                  right: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: gold.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          card.romanNumeral,
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: gold,
                          ),
                        ),
                      ),
                      if (isCustomized)
                        Container(
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            color: gold,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            card.hasCustomImage
                                ? Icons.auto_awesome
                                : Icons.edit,
                            size: 9,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),

                // 4. Bottom Title Banner
                Positioned(
                  bottom: 6,
                  left: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: gold.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      card.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark, Color gold) {
    return Container(
      color: isDark ? const Color(0xFF140D24) : const Color(0xFF2A2038),
      child: Center(
        child: Icon(
          Icons.auto_fix_normal,
          size: 24,
          color: gold.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
