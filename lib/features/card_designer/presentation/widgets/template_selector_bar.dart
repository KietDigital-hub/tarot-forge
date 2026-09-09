import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/card_template.dart';
import '../providers/card_designer_provider.dart';

/// Horizontal selector bar allowing instantaneous switching between
/// the 4 tarot card templates with real-time feedback.
class TemplateSelectorBar extends ConsumerWidget {
  final bool isDark;

  const TemplateSelectorBar({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCard = ref.watch(cardDesignerProvider);
    final activeId = selectedCard.templateId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 14,
                color: isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                'MẪU LÁ BÀI',
                style: AppTypography.sectionHeader(isDark: isDark),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 92,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            scrollDirection: Axis.horizontal,
            itemCount: CardTemplate.allTemplates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final template = CardTemplate.allTemplates[index];
              final isSelected = template.id == activeId;

              final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

              return InkWell(
                onTap: () {
                  ref.read(cardDesignerProvider.notifier).selectTemplate(template.id);
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  width: 154,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant)
                        : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? gold : gold.withValues(alpha: 0.25),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: gold.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getIconForTemplate(template.id),
                            size: 16,
                            color: isSelected ? gold : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              template.name,
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? gold : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        template.description,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 9.5,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getIconForTemplate(String id) {
    switch (id) {
      case 'classic_arcana':
        return Icons.filter_vintage_outlined;
      case 'celestial_mystic':
        return Icons.star_border_purple500_sharp;
      case 'minimalist_alchemy':
        return Icons.crop_square_outlined;
      case 'full_bleed_art':
        return Icons.fullscreen;
      default:
        return Icons.style_outlined;
    }
  }
}
