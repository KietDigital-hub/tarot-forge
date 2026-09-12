import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/mystic_particles.dart';
import '../../../card_designer/presentation/providers/card_designer_provider.dart';
import '../../../card_designer/presentation/screens/card_designer_screen.dart';
import '../../../card_designer/presentation/widgets/card_back_editor_sheet.dart';
import '../../../card_designer/presentation/widgets/export_action_sheet.dart';
import '../providers/deck_provider.dart';
import '../widgets/deck_progress_card.dart';
import '../widgets/mini_card_tile.dart';

enum DeckCategoryFilter {
  all,
  major,
  wands,
  cups,
  swords,
  pentacles,
  customized,
}

extension DeckCategoryFilterExtension on DeckCategoryFilter {
  String get label {
    switch (this) {
      case DeckCategoryFilter.all:
        return 'Tất Cả (78)';
      case DeckCategoryFilter.major:
        return 'Ẩn Chính (22)';
      case DeckCategoryFilter.wands:
        return 'Gậy 🔥 (14)';
      case DeckCategoryFilter.cups:
        return 'Chén 💧 (14)';
      case DeckCategoryFilter.swords:
        return 'Kiếm 💨 (14)';
      case DeckCategoryFilter.pentacles:
        return 'Tiền 🌍 (14)';
      case DeckCategoryFilter.customized:
        return 'Đã Tùy Biến ✨';
    }
  }
}

/// Primary Screen for managing the entire 78-card Tarot Deck.
class DeckManagerScreen extends ConsumerStatefulWidget {
  const DeckManagerScreen({super.key});

  @override
  ConsumerState<DeckManagerScreen> createState() => _DeckManagerScreenState();
}

class _DeckManagerScreenState extends ConsumerState<DeckManagerScreen> {
  DeckCategoryFilter _activeFilter = DeckCategoryFilter.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCardInDesigner(String cardId) {
    final deck = ref.read(deckProvider);
    final card = deck.getCardById(cardId);
    if (card != null) {
      ref.read(activeCardIdProvider.notifier).selectCard(cardId);
      ref.read(cardDesignerProvider.notifier).loadCard(card);

      // Check if we were pushed from CardDesignerScreen
      final canPop = Navigator.of(context).canPop();
      if (canPop) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CardDesignerScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deck = ref.watch(deckProvider);
    final activeCardId = ref.watch(activeCardIdProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;

    // Filter cards
    List cardsToDisplay;
    switch (_activeFilter) {
      case DeckCategoryFilter.all:
        cardsToDisplay = deck.cards;
        break;
      case DeckCategoryFilter.major:
        cardsToDisplay = deck.majorArcana;
        break;
      case DeckCategoryFilter.wands:
        cardsToDisplay = deck.wands;
        break;
      case DeckCategoryFilter.cups:
        cardsToDisplay = deck.cups;
        break;
      case DeckCategoryFilter.swords:
        cardsToDisplay = deck.swords;
        break;
      case DeckCategoryFilter.pentacles:
        cardsToDisplay = deck.pentacles;
        break;
      case DeckCategoryFilter.customized:
        cardsToDisplay = deck.customizedCards;
        break;
    }

    // Search query filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      cardsToDisplay = cardsToDisplay.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.romanNumeral.toLowerCase().contains(q) ||
            c.subtitle.toLowerCase().contains(q) ||
            c.englishName.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'BỘ BÀI TAROT (78 LÁ)',
              style: AppTypography.screenTitle(isDark: isDark),
            ),
            Text(
              'RIDER-WAITE • TOÀN BỘ ẨN CHÍNH & ẨN PHỤ',
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
          // Search Toggle
          IconButton(
            tooltip: 'Tìm kiếm lá bài',
            icon: Icon(
              _isSearchExpanded ? Icons.close : Icons.search,
              color: gold,
            ),
            onPressed: () {
              setState(() {
                _isSearchExpanded = !_isSearchExpanded;
                if (!_isSearchExpanded) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Batch Export
          IconButton(
            tooltip: 'Xuất in ấn hàng loạt',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            color: gold,
            onPressed: () => ExportActionSheet.show(context, isDark),
          ),
        ],
      ),
      body: MysticParticlesOverlay(
        child: SafeArea(
          child: Column(
            children: [
              // 1. Deck Progress & Quick Actions
              DeckProgressCard(
                deck: deck,
                isDark: isDark,
                onEditCardBack: () => CardBackEditorSheet.show(context, isDark),
                onBatchExport: () => ExportActionSheet.show(context, isDark),
              ),

              // 2. Search Field (if expanded)
              if (_isSearchExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên, số La Mã hoặc từ khóa...',
                      prefixIcon: Icon(Icons.search, color: gold),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: gold),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: gold, width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                      });
                    },
                  ),
                ),

              // 3. Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Row(
                  children: DeckCategoryFilter.values.map((filter) {
                    final isSelected = _activeFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(filter.label),
                        selected: isSelected,
                        onSelected: (sel) {
                          if (sel) {
                            setState(() => _activeFilter = filter);
                          }
                        },
                        selectedColor: gold.withValues(alpha: isDark ? 0.35 : 0.25),
                        backgroundColor: isDark
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant,
                        labelStyle: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? gold
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        side: BorderSide(
                          color: isSelected ? gold : Colors.transparent,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // 4. Card Grid
              Expanded(
                child: cardsToDisplay.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.style_outlined, size: 48, color: gold.withValues(alpha: 0.5)),
                            const SizedBox(height: 12),
                            Text(
                              'Không tìm thấy lá bài phù hợp',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 140,
                          childAspectRatio: 0.5833, // 70:120 Tarot ratio
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: cardsToDisplay.length,
                        itemBuilder: (context, index) {
                          final card = cardsToDisplay[index];
                          final isSelected = card.id == activeCardId;

                          return MiniCardTile(
                            card: card,
                            isDark: isDark,
                            isSelected: isSelected,
                            onTap: () => _openCardInDesigner(card.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
