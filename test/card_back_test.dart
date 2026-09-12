import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/core/widgets/card_back_painter.dart';
import 'package:tarot_forge/features/card_designer/domain/models/card_back_design.dart';
import 'package:tarot_forge/features/card_designer/presentation/widgets/card_back_preview.dart';

void main() {
  group('CardBackDesign Model & Patterns', () {
    test('Default design has valid celestial compass properties', () {
      const design = CardBackDesign();
      expect(design.pattern, CardBackPattern.celestialCompass);
      expect(design.hasCustomImage, isFalse);
      expect(design.pattern.displayName, 'La Bàn Thiên Thể');
      expect(design.pattern.description.isNotEmpty, isTrue);
    });

    test('All CardBackPattern enum values have Vietnamese display names and descriptions', () {
      for (final pattern in CardBackPattern.values) {
        expect(pattern.displayName.isNotEmpty, isTrue);
        expect(pattern.description.isNotEmpty, isTrue);
      }
    });

    test('copyWith updates properties as expected', () {
      const design = CardBackDesign();
      final updated = design.copyWith(
        pattern: CardBackPattern.sacredGeometry,
        backgroundColor: Colors.black,
      );

      expect(updated.pattern, CardBackPattern.sacredGeometry);
      expect(updated.backgroundColor, Colors.black);
      expect(updated.foilColor, design.foilColor);
    });
  });

  group('CardBackPreview Widget & Painter', () {
    testWidgets('Renders CardBackPreview with Sacred Geometry pattern', (tester) async {
      const design = CardBackDesign(pattern: CardBackPattern.sacredGeometry);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 210,
                height: 360,
                child: CardBackPreview(
                  design: design,
                  isDark: true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CardBackPreview), findsOneWidget);
      expect(
        find.byWidgetPredicate(
            (w) => w is CustomPaint && w.painter is CardBackPainter),
        findsOneWidget,
      );
    });

    testWidgets('Renders all 4 sacred vector patterns without paint errors', (tester) async {
      final patterns = [
        CardBackPattern.sacredGeometry,
        CardBackPattern.celestialCompass,
        CardBackPattern.alchemicalOuroboros,
        CardBackPattern.mysticSunMoon,
      ];

      for (final pattern in patterns) {
        final design = CardBackDesign(pattern: pattern);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 210,
                  height: 360,
                  child: CardBackPreview(
                    design: design,
                    isDark: true,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CardBackPreview), findsOneWidget);
        await tester.pump();
      }
    });
  });
}
