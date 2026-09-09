import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/gold_shimmer_border.dart';
import '../../../../core/widgets/tilt_card_container.dart';
import '../providers/card_designer_provider.dart';
import '../widgets/card_canvas_preview.dart';
import '../widgets/card_text_editor_sheet.dart';
import '../widgets/export_action_sheet.dart';
import '../widgets/image_picker_sheet.dart';
import '../widgets/template_selector_bar.dart';

/// Primary screen for Phase 1: Interactive Tarot Card Designer.
class CardDesignerScreen extends ConsumerWidget {
  const CardDesignerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCard = ref.watch(cardDesignerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'TAROT FORGE',
              style: AppTypography.screenTitle(isDark: isDark),
            ),
            Text(
              '70 x 120 mm • XƯỞNG IN 300 DPI',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 9.5,
                letterSpacing: 2.0,
                color: gold,
              ),
            ),
          ],
        ),
        actions: [
          // Dark / Light Mode Toggle
          IconButton(
            tooltip: isDark ? 'Chuyển sang giao diện sáng' : 'Chuyển sang giao diện tối',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
                key: ValueKey(isDark),
                color: gold,
              ),
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          // Export Button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              tooltip: 'Xuất PDF sẵn sàng in',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              color: gold,
              onPressed: () => ExportActionSheet.show(context, isDark),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Hero Card Preview Stage
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Interactive 3D Card
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 460,
                            maxWidth: 270,
                          ),
                          child: TiltCardContainer(
                            borderRadius: BorderRadius.circular(14),
                            child: GoldShimmerBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderWidth: 2.0,
                              child: CardCanvasPreview(
                                card: activeCard,
                                isDark: isDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Tactile hint label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 13,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Kéo hoặc di chuột để xoay lá bài 3D',
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
            ),

            // Bottom Control Dock
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border(
                  top: BorderSide(
                    color: gold.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  // Template Selector Bar
                  TemplateSelectorBar(isDark: isDark),

                  const SizedBox(height: 6),

                  // Quick Action Toolbar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        // Edit Inscription Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => CardTextEditorSheet.show(context, isDark),
                            icon: const Icon(Icons.edit_note, size: 18),
                            label: const Text('VĂN BẢN'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Change Artwork Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => ImagePickerSheet.show(context, isDark),
                            icon: const Icon(Icons.photo_library_outlined, size: 18),
                            label: const Text('HÌNH ẢNH'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Export Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => ExportActionSheet.show(context, isDark),
                            icon: const Icon(Icons.print_outlined, size: 18),
                            label: const Text('XUẤT FILE'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
