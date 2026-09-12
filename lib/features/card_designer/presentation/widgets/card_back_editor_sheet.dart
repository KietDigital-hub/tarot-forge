import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../deck_manager/presentation/providers/deck_provider.dart';
import '../../domain/models/card_back_design.dart';
import '../providers/card_designer_provider.dart';
import 'card_back_preview.dart';

/// Modal bottom sheet for customizing the card back's sacred pattern and foil colors.
class CardBackEditorSheet extends ConsumerStatefulWidget {
  final bool isDark;

  const CardBackEditorSheet({super.key, required this.isDark});

  static Future<void> show(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CardBackEditorSheet(isDark: isDark),
    );
  }

  @override
  ConsumerState<CardBackEditorSheet> createState() => _CardBackEditorSheetState();
}

class _CardBackEditorSheetState extends ConsumerState<CardBackEditorSheet> {
  late CardBackDesign _workingDesign;

  final List<Color> _bgColors = const [
    Color(0xFF0F0B1E), // Deep Astral Purple
    Color(0xFF0D0D0D), // Obsidian Black
    Color(0xFF2B0C14), // Royal Crimson Velvet
    Color(0xFF0B192C), // Midnight Navy
    Color(0xFF0D2818), // Dark Emerald Forest
  ];

  final List<Map<String, dynamic>> _foilColors = const [
    {
      'name': 'Vàng Hoàng Kim',
      'primary': Color(0xFFD4AF37),
      'secondary': Color(0xFFFFF0A8),
    },
    {
      'name': 'Bạc Tinh Tú',
      'primary': Color(0xFFE0E1DD),
      'secondary': Color(0xFFFFFFFF),
    },
    {
      'name': 'Đồng Cổ Điển',
      'primary': Color(0xFFCD7F32),
      'secondary': Color(0xFFFFD1A4),
    },
    {
      'name': 'Hồng Thạch Anh',
      'primary': Color(0xFFE0A96D),
      'secondary': Color(0xFFFFE5D9),
    },
  ];

  @override
  void initState() {
    super.initState();
    _workingDesign = ref.read(cardBackProvider);
  }

  void _applyAndClose() {
    ref.read(cardBackProvider.notifier).updateDesign(_workingDesign);
    ref.read(deckProvider.notifier).updateCardBack(_workingDesign);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✨ Đã áp dụng mẫu "${_workingDesign.pattern.displayName}" cho toàn bộ 78 lá bài!',
          style: const TextStyle(fontFamily: 'Outfit'),
        ),
        backgroundColor: AppColors.goldDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: gold.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THIẾT KẾ MẶT SAU',
                      style: AppTypography.screenTitle(isDark: isDark),
                    ),
                    Text(
                      'Họa tiết đối xứng huyền bí chuẩn in ấn',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: gold,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main scrollable body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Live Miniature Preview
                Center(
                  child: SizedBox(
                    height: 220,
                    child: CardBackPreview(
                      design: _workingDesign,
                      isDark: isDark,
                      showShadow: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 1. Select Pattern
                Text(
                  '1. CHỌN HOA VĂN THIÊNG LIÊNG',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 10),
                ...CardBackPattern.values
                    .where((p) => p != CardBackPattern.customArt)
                    .map((pattern) {
                  final isSelected = _workingDesign.pattern == pattern;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? gold.withValues(alpha: isDark ? 0.18 : 0.12)
                          : (isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.lightSurfaceVariant),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? gold : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _workingDesign = _workingDesign.copyWith(
                            pattern: pattern,
                            clearCustomImage: true,
                          );
                        });
                      },
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gold.withValues(alpha: 0.2),
                        ),
                        child: Icon(
                          _getPatternIcon(pattern),
                          color: gold,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        pattern.displayName,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      subtitle: Text(
                        pattern.description,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: gold)
                          : null,
                    ),
                  );
                }),
                const SizedBox(height: 18),

                // 2. Select Foil Metallic Accent
                Text(
                  '2. MÀU ÁNH KIM / NHŨ KIM LOẠI',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _foilColors.map((foil) {
                    final Color pColor = foil['primary'];
                    final Color sColor = foil['secondary'];
                    final isSelected = _workingDesign.foilColor == pColor;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _workingDesign = _workingDesign.copyWith(
                            foilColor: pColor,
                            secondaryFoilColor: sColor,
                          );
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? pColor.withValues(alpha: 0.2)
                              : (isDark
                                  ? AppColors.darkSurfaceVariant
                                  : AppColors.lightSurfaceVariant),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? pColor : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: pColor,
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              foil['name'] as String,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                // 3. Select Background Base Color
                Text(
                  '3. NỀN GIẤY BÀI HUYỀN BÍ',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _bgColors.map((bgColor) {
                    final isSelected = _workingDesign.backgroundColor == bgColor;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _workingDesign = _workingDesign.copyWith(
                              backgroundColor: bgColor,
                            );
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 42,
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? gold : Colors.white24,
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: gold.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? Icon(Icons.check, size: 20, color: gold)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _applyAndClose,
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: const Text('ÁP DỤNG CHO TOÀN BỘ 78 LÁ BÀI'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: gold,
                  foregroundColor:
                      isDark ? const Color(0xFF0D0D0D) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPatternIcon(CardBackPattern pattern) {
    switch (pattern) {
      case CardBackPattern.sacredGeometry:
        return Icons.all_inclusive;
      case CardBackPattern.celestialCompass:
        return Icons.explore_outlined;
      case CardBackPattern.alchemicalOuroboros:
        return Icons.change_circle_outlined;
      case CardBackPattern.mysticSunMoon:
        return Icons.wb_twilight_outlined;
      case CardBackPattern.customArt:
        return Icons.image_outlined;
    }
  }
}
