import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/tarot_deck_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/card_designer_provider.dart';

/// Modal bottom sheet for editing card text, numerals, and keywords.
class CardTextEditorSheet extends ConsumerStatefulWidget {
  final bool isDark;

  const CardTextEditorSheet({super.key, required this.isDark});

  static Future<void> show(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CardTextEditorSheet(isDark: isDark),
    );
  }

  @override
  ConsumerState<CardTextEditorSheet> createState() => _CardTextEditorSheetState();
}

class _CardTextEditorSheetState extends ConsumerState<CardTextEditorSheet> {
  late TextEditingController _nameController;
  late TextEditingController _numeralController;
  late TextEditingController _subtitleController;

  @override
  void initState() {
    super.initState();
    final card = ref.read(cardDesignerProvider);
    _nameController = TextEditingController(text: card.name);
    _numeralController = TextEditingController(text: card.romanNumeral);
    _subtitleController = TextEditingController(text: card.subtitle);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numeralController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.edit_note, color: gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'NỘI DUNG LÁ BÀI',
                style: AppTypography.screenTitle(isDark: isDark),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Presets row
          Text(
            'MẪU CÓ SẴN',
            style: AppTypography.sectionHeader(isDark: isDark),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: TarotDeckData.samplePresets.map((preset) {
              return ActionChip(
                backgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightSurfaceVariant,
                side: BorderSide(color: gold.withValues(alpha: 0.3)),
                avatar: Text(
                  preset.romanNumeral,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: gold,
                  ),
                ),
                label: Text(
                  preset.name,
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                onPressed: () {
                  ref.read(cardDesignerProvider.notifier).applyPreset(preset);
                  _nameController.text = preset.name;
                  _numeralController.text = preset.romanNumeral;
                  _subtitleController.text = preset.keywords;
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Roman Numeral field
          _buildTextField(
            controller: _numeralController,
            label: 'SỐ LA MÃ',
            hint: 'VD: XVII, 0, I, IX',
            isDark: isDark,
            gold: gold,
            onChanged: (val) =>
                ref.read(cardDesignerProvider.notifier).updateNumeral(val),
          ),
          const SizedBox(height: 14),

          // Card Name field
          _buildTextField(
            controller: _nameController,
            label: 'TÊN LÁ BÀI',
            hint: 'VD: NGÔI SAO, KẺ NGỐC, NỮ HOÀNG',
            isDark: isDark,
            gold: gold,
            onChanged: (val) =>
                ref.read(cardDesignerProvider.notifier).updateName(val),
          ),
          const SizedBox(height: 14),

          // Subtitle / Keywords field
          _buildTextField(
            controller: _subtitleController,
            label: 'TỪ KHÓA / Ý NGHĨA',
            hint: 'VD: Hy Vọng • Cảm Hứng • Tái Sinh',
            isDark: isDark,
            gold: gold,
            onChanged: (val) =>
                ref.read(cardDesignerProvider.notifier).updateSubtitle(val),
          ),

          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('ÁP DỤNG'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    required Color gold,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            filled: true,
            fillColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: gold.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: gold, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
