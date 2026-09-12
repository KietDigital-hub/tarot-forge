import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/features/deck_manager/presentation/screens/deck_manager_screen.dart';
import 'package:tarot_forge/features/deck_manager/presentation/widgets/deck_progress_card.dart';
import 'package:tarot_forge/features/deck_manager/presentation/widgets/mini_card_tile.dart';

void main() {
  group('Deck Manager Flow Integration Widget Test', () {
    testWidgets('Renders DeckManagerScreen with progress card, category tabs and card tiles', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DeckManagerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify screen title and progress card
      expect(find.text('BỘ BÀI TAROT (78 LÁ)'), findsOneWidget);
      expect(find.byType(DeckProgressCard), findsOneWidget);
      expect(find.textContaining('78 lá'), findsWidgets);

      // Verify category filter chips
      expect(find.text('Tất Cả (78)'), findsOneWidget);
      expect(find.text('Ẩn Chính (22)'), findsOneWidget);

      // Verify mini card tiles exist in grid
      expect(find.byType(MiniCardTile), findsWidgets);
    });

    testWidgets('Filtering by suit updates the visible cards in the grid', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: DeckManagerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on 'Ẩn Chính (22)'
      final majorFilter = find.text('Ẩn Chính (22)');
      expect(majorFilter, findsOneWidget);
      await tester.tap(majorFilter);
      await tester.pumpAndSettle();

      // Should find 'KẺ KHỜ' (Major 0)
      expect(find.text('KẺ KHỜ'), findsOneWidget);
    });
  });
}
