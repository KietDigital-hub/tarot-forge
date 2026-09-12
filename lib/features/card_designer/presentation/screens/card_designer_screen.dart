import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/gold_shimmer_border.dart';
import '../../../../core/widgets/mystic_particles.dart';
import '../../../../core/widgets/tilt_card_container.dart';
import '../../../customer_profile/presentation/providers/customer_profile_provider.dart';
import '../../../deck_manager/presentation/providers/deck_provider.dart';
import '../../../deck_manager/presentation/screens/deck_manager_screen.dart';
import '../../../help/presentation/screens/help_guide_screen.dart';
import '../providers/card_designer_provider.dart';
import '../widgets/card_back_editor_sheet.dart';
import '../widgets/card_back_preview.dart';
import '../widgets/card_canvas_preview.dart';
import '../widgets/card_text_editor_sheet.dart';
import '../widgets/export_action_sheet.dart';
import '../widgets/image_picker_sheet.dart';
import '../widgets/template_selector_bar.dart';

/// Primary screen for Interactive Tarot Card Designer with 3D Flip,
/// Deck Navigation (78 cards), and Back-Side Designer.
class CardDesignerScreen extends ConsumerStatefulWidget {
  const CardDesignerScreen({super.key});

  @override
  ConsumerState<CardDesignerScreen> createState() => _CardDesignerScreenState();
}

class _CardDesignerScreenState extends ConsumerState<CardDesignerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleCardFlip() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
      ref.read(cardFlipProvider.notifier).showFront();
    } else {
      _flipController.forward();
      ref.read(cardFlipProvider.notifier).showBack();
    }
  }

  void _navigateDeckCard(int delta) {
    final deck = ref.read(deckProvider);
    final activeCard = ref.read(cardDesignerProvider);
    final allCards = deck.cards;

    final currentIndex = allCards.indexWhere((c) => c.id == activeCard.id);
    if (currentIndex == -1) return;

    final newIndex = (currentIndex + delta + allCards.length) % allCards.length;
    final nextCard = allCards[newIndex];

    ref.read(activeCardIdProvider.notifier).selectCard(nextCard.id);
    ref.read(cardDesignerProvider.notifier).loadCard(nextCard);

    // If card was flipped to back, gently flip it back to front on card change
    if (_flipController.isCompleted) {
      _flipController.reverse();
      ref.read(cardFlipProvider.notifier).showFront();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCard = ref.watch(cardDesignerProvider);
    final cardBack = ref.watch(cardBackProvider);
    final themeMode = ref.watch(themeModeProvider);
    final customerProfile = ref.watch(customerProfileProvider);
    final deck = ref.watch(deckProvider);
    final isDark = themeMode == ThemeMode.dark;

    final palette = customerProfile.palette;
    final accentColor = palette.getAccent(isDark);
    final secondaryAccent = palette.getSecondaryAccent(isDark);

    // Synchronize current card to deck state
    ref.listen(cardDesignerProvider, (_, current) {
      ref.read(deckProvider.notifier).updateCard(current);
    });

    final currentCardIndex = deck.cards.indexWhere((c) => c.id == activeCard.id) + 1;
    final totalCardCount = deck.cards.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'TAROT FORGE',
              style: AppTypography.screenTitle(isDark: isDark),
            ),
            Text(
              'LÁ $currentCardIndex/$totalCardCount • 70x120mm 300 DPI',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 9.5,
                letterSpacing: 2.0,
                color: accentColor,
              ),
            ),
          ],
        ),
        actions: [
          // Deck Manager Screen Button
          IconButton(
            tooltip: 'Danh sách 78 lá bài',
            icon: Icon(Icons.grid_view_rounded, color: accentColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DeckManagerScreen(),
                ),
              );
            },
          ),
          // Help / Usage Guide
          IconButton(
            tooltip: 'Hướng dẫn sử dụng',
            icon: Icon(Icons.help_outline, color: accentColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HelpGuideScreen(isDark: isDark),
                ),
              );
            },
          ),
          // Dark / Light Mode Toggle
          IconButton(
            tooltip: isDark ? 'Chuyển sang giao diện sáng' : 'Chuyển sang giao diện tối',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
                key: ValueKey(isDark),
                color: accentColor,
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
              color: accentColor,
              onPressed: () => ExportActionSheet.show(context, isDark),
            ),
          ),
        ],
      ),
      body: MysticParticlesOverlay(
        child: Container(
          decoration: BoxDecoration(
            gradient: palette.getBackgroundGradient(isDark),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Customer Profile & Deck Switcher Bar
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DeckManagerScreen(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: palette.getBadgeBackground(isDark),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: palette.getBadgeBorder(isDark)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.style, size: 15, color: accentColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'Bộ bài: ',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11.5,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.lightTextMuted,
                              ),
                              children: [
                                TextSpan(
                                  text: '${customerProfile.name} • ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text: '${deck.customizedCount}/78 lá đã tùy biến',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'ĐỔI LÁ',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.arrow_drop_down, size: 14, color: accentColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero Card Preview Stage with 3D Flip & Card Navigation
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Card Navigation Row (< Card Stage >)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Previous Card Arrow
                                IconButton(
                                  tooltip: 'Lá bài trước',
                                  icon: Icon(
                                    Icons.chevron_left_rounded,
                                    size: 36,
                                    color: accentColor.withValues(alpha: 0.8),
                                  ),
                                  onPressed: () => _navigateDeckCard(-1),
                                ),

                                // Interactive 3D Flip Card
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
                                        baseColor: accentColor,
                                        accentColor: secondaryAccent,
                                        child: AnimatedBuilder(
                                          animation: _flipAnimation,
                                          builder: (context, child) {
                                            final angle = _flipAnimation.value * math.pi;
                                            final isFront = angle <= math.pi / 2;

                                            return Transform(
                                              transform: Matrix4.identity()
                                                ..setEntry(3, 2, 0.001)
                                                ..rotateY(isFront ? angle : angle - math.pi),
                                              alignment: Alignment.center,
                                              child: isFront
                                                  ? CardCanvasPreview(
                                                      card: activeCard,
                                                      isDark: isDark,
                                                    )
                                                  : CardBackPreview(
                                                      design: cardBack,
                                                      isDark: isDark,
                                                    ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Next Card Arrow
                                IconButton(
                                  tooltip: 'Lá bài tiếp theo',
                                  icon: Icon(
                                    Icons.chevron_right_rounded,
                                    size: 36,
                                    color: accentColor.withValues(alpha: 0.8),
                                  ),
                                  onPressed: () => _navigateDeckCard(1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 3D Flip & Tilt Action Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 3D Flip Button
                              InkWell(
                                onTap: _toggleCardFlip,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.flip_camera_android_rounded,
                                        size: 14,
                                        color: accentColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _flipController.value > 0.5
                                            ? 'XEM MẶT TRƯỚC'
                                            : 'LẬT MẶT SAU',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Back Editor Button
                              InkWell(
                                onTap: () => CardBackEditorSheet.show(context, isDark),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.palette_outlined,
                                        size: 13,
                                        color: accentColor,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'CHỌN HOA VĂN MẶT SAU',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
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
                        color: accentColor.withValues(alpha: 0.35),
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
                      TemplateSelectorBar(
                        isDark: isDark,
                        accentColor: accentColor,
                      ),

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
                                  foregroundColor: accentColor,
                                  side: BorderSide(
                                    color: accentColor.withValues(alpha: 0.6),
                                    width: 1.2,
                                  ),
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
                                  foregroundColor: accentColor,
                                  side: BorderSide(
                                    color: accentColor.withValues(alpha: 0.6),
                                    width: 1.2,
                                  ),
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
                                  backgroundColor: accentColor,
                                  foregroundColor: accentColor.computeLuminance() > 0.45
                                      ? const Color(0xFF0D0A14)
                                      : Colors.white,
                                  shadowColor: accentColor.withValues(alpha: 0.45),
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
        ),
      ),
    );
  }
}
