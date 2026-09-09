import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/core/constants/tarot_constants.dart';
import 'package:tarot_forge/core/utils/unit_converter.dart';
import 'package:tarot_forge/features/card_designer/domain/models/card_template.dart';
import 'package:tarot_forge/features/card_designer/domain/models/tarot_card.dart';
import 'package:tarot_forge/features/card_designer/services/pdf_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tarot Constants & Dimensions', () {
    test('Standard Rider-Waite dimensions match 70x120mm with 3mm bleed', () {
      expect(TarotConstants.trimWidthMm, 70.0);
      expect(TarotConstants.trimHeightMm, 120.0);
      expect(TarotConstants.bleedMm, 3.0);
      expect(TarotConstants.fullWidthWithBleedMm, 76.0);
      expect(TarotConstants.fullHeightWithBleedMm, 126.0);
    });

    test('Unit converter correctly calculates 300 DPI pixels', () {
      // 70 mm in 300 DPI
      expect(UnitConverter.mmToPx(70.0), 827);
      // 120 mm in 300 DPI
      expect(UnitConverter.mmToPx(120.0), 1417);
      // 76 mm (with bleed)
      expect(UnitConverter.mmToPx(76.0), 898);
      // 126 mm (with bleed)
      expect(UnitConverter.mmToPx(126.0), 1488);
    });

    test('All 4 Phase-1 templates are defined', () {
      expect(CardTemplate.allTemplates.length, 4);
      final ids = CardTemplate.allTemplates.map((t) => t.id).toList();
      expect(ids, contains('classic_arcana'));
      expect(ids, contains('celestial_mystic'));
      expect(ids, contains('minimalist_alchemy'));
      expect(ids, contains('full_bleed_art'));
    });
  });

  group('PDF Prepress Generator', () {
    test('Generates valid non-empty PDF bytes for Tarot card', () async {
      const card = TarotCard(
        id: 'test_card',
        romanNumeral: 'XVII',
        name: 'THE STAR',
        subtitle: 'Hope • Inspiration • Serenity',
        templateId: 'classic_arcana',
      );

      final pdfBytes = await PdfExportService.generatePrintReadyPdf(
        card: card,
        isDark: true,
        includeCropMarks: true,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(1000));
      // Standard PDF header signature %PDF-
      expect(pdfBytes[0], 0x25); // %
      expect(pdfBytes[1], 0x50); // P
      expect(pdfBytes[2], 0x44); // D
      expect(pdfBytes[3], 0x46); // F
    });
  });
}
