import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/core/constants/tarot_78_cards_data.dart';
import 'package:tarot_forge/features/card_designer/domain/models/card_back_design.dart';
import 'package:tarot_forge/features/card_designer/domain/models/tarot_card.dart';
import 'package:tarot_forge/features/card_designer/services/pdf_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Batch PDF Prepress Generator', () {
    test('Generates valid multi-page PDF for selected Tarot cards', () async {
      final sampleDefs = Tarot78CardsData.majorArcana.take(3).toList();
      final sampleCards = sampleDefs
          .map((def) => TarotCard.fromDefinition(def, templateId: 'classic_arcana'))
          .toList();

      final Uint8List pdfBytes =
          await PdfExportService.generateBatchPrintReadyPdf(
        cards: sampleCards,
        isDark: true,
        includeCropMarks: true,
        includeCardBacks: false,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      // PDF header %PDF-
      expect(pdfBytes[0], 0x25); // %
      expect(pdfBytes[1], 0x50); // P
      expect(pdfBytes[2], 0x44); // D
      expect(pdfBytes[3], 0x46); // F
    });

    test('Generates duplex PDF with matching card backs when enabled', () async {
      final sampleDefs = Tarot78CardsData.majorArcana.take(2).toList();
      final sampleCards = sampleDefs
          .map((def) => TarotCard.fromDefinition(def, templateId: 'celestial_mystic'))
          .toList();

      const backDesign = CardBackDesign(
        pattern: CardBackPattern.celestialCompass,
      );

      final Uint8List pdfBytes =
          await PdfExportService.generateBatchPrintReadyPdf(
        cards: sampleCards,
        cardBack: backDesign,
        isDark: true,
        includeCropMarks: true,
        includeCardBacks: true,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(1000));
    });
  });
}
