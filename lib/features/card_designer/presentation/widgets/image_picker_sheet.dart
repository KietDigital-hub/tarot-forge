import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/tarot_deck_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/card_designer_provider.dart';

/// Modal sheet for selecting an image: device upload or bundled vintage tarot art.
class ImagePickerSheet extends ConsumerWidget {
  final bool isDark;

  const ImagePickerSheet({super.key, required this.isDark});

  static Future<void> show(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ImagePickerSheet(isDark: isDark),
    );
  }

  Future<void> _pickCustomFile(BuildContext context, WidgetRef ref) async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );

      if (file != null) {
        final bytes = await file.xFile.readAsBytes();
        ref.read(cardDesignerProvider.notifier).setCustomImage(
              bytes,
              file.name,
            );
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã tải hình minh họa "${file.name}"!'),
              backgroundColor: AppColors.goldDark,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi chọn ảnh: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final activeCard = ref.watch(cardDesignerProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
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
              Icon(Icons.image_outlined, color: gold, size: 20),
              const SizedBox(width: 8),
              Text(
                'HÌNH ẢNH LÁ BÀI',
                style: AppTypography.screenTitle(isDark: isDark),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Upload custom file button
          InkWell(
            onTap: () => _pickCustomFile(context, ref),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: gold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_upload_outlined, color: gold, size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TẢI LÊN TỪ THIẾT BỊ',
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: gold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ảnh chất lượng cao định dạng PNG, JPG hoặc WEBP',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 22),
          Text(
            'THƯ VIỆN HÌNH ẢNH CÓ SẴN',
            style: AppTypography.sectionHeader(isDark: isDark),
          ),
          const SizedBox(height: 10),

          // Gallery row
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: TarotDeckData.samplePresets.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final preset = TarotDeckData.samplePresets[index];
                final isSelected = !activeCard.hasCustomImage &&
                    activeCard.assetImagePath == preset.assetImagePath;

                return InkWell(
                  onTap: () {
                    ref
                        .read(cardDesignerProvider.notifier)
                        .selectAssetImage(preset.assetImagePath);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? gold : gold.withValues(alpha: 0.25),
                        width: isSelected ? 2.5 : 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            preset.assetImagePath,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                preset.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: AppColors.goldPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
