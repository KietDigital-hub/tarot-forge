import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/features/card_designer/domain/models/tarot_card.dart';
import 'package:tarot_forge/features/card_designer/services/pdf_export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Export physical print-ready PDF file for inspection', () async {
    // Read the sample image from assets
    final starImageFile = File('assets/images/the_star.jpg');
    expect(starImageFile.existsSync(), isTrue,
        reason: 'Asset image must exist');
    final imageBytes = await starImageFile.readAsBytes();

    final card = TarotCard(
      id: 'the_star',
      romanNumeral: 'XVII',
      name: 'THE STAR',
      subtitle: 'Hope • Inspiration • Serenity',
      templateId: 'classic_arcana',
      customImageBytes: imageBytes,
      customImageName: 'the_star.jpg',
    );

    final pdfBytes = await PdfExportService.generatePrintReadyPdf(
      card: card,
      isDark: true,
      includeCropMarks: true,
    );

    expect(pdfBytes.isNotEmpty, isTrue);

    // Save to workspace output
    final outputDir = Directory('output');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final outputFile = File('output/tarot_the_star_print_ready.pdf');
    await outputFile.writeAsBytes(pdfBytes);

    // Also save to artifact directory
    final artifactFile = File(
      'C:/Users/kiett/.gemini/antigravity-ide/brain/900c2c76-e31b-4dda-8b9b-635d2c50f984/tarot_the_star_print_ready.pdf',
    );
    await artifactFile.writeAsBytes(pdfBytes);

    print('PDF successfully generated at: ${outputFile.absolute.path}');
    print('Artifact PDF successfully generated at: ${artifactFile.absolute.path}');
  });
}
