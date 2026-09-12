import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/tarot_deck.dart';

/// Card showing progress of the 78-card deck completion, with quick actions.
class DeckProgressCard extends StatelessWidget {
  final TarotDeck deck;
  final bool isDark;
  final VoidCallback onEditCardBack;
  final VoidCallback onBatchExport;

  const DeckProgressCard({
    super.key,
    required this.deck,
    required this.isDark,
    required this.onEditCardBack,
    required this.onBatchExport,
  });

  @override
  Widget build(BuildContext context) {
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final progress = deck.progress;
    final percent = deck.progressPercentage;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title and percentage badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: gold, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'TIẾN ĐỘ BỘ BÀI (78 LÁ)',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: gold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: gold.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${deck.customizedCount} / ${deck.totalCount} lá • $percent%',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(gold),
            ),
          ),
          const SizedBox(height: 14),

          // Action Buttons: Mặt Sau & Xuất Hàng Loạt
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEditCardBack,
                  icon: const Icon(Icons.style_outlined, size: 16),
                  label: const Text('MẶT SAU BÀI'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: gold.withValues(alpha: 0.5)),
                    foregroundColor: gold,
                    textStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onBatchExport,
                  icon: const Icon(Icons.print_outlined, size: 16),
                  label: const Text('XUẤT TRỌN BỘ'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: gold,
                    foregroundColor:
                        isDark ? const Color(0xFF0D0D0D) : Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
