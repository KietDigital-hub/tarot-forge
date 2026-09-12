import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/constants/tarot_constants.dart';
import '../domain/models/card_back_design.dart';
import '../domain/models/card_template.dart';
import '../domain/models/tarot_card.dart';

/// Prepress PDF export engine producing 300 DPI, print-ready Tarot cards
/// conforming to standard Rider-Waite dimensions (70 x 120 mm) with 3mm bleed
/// and standard printer crop crosshairs.
class PdfExportService {
  PdfExportService._();

  /// Generates print-ready PDF bytes for a single [TarotCard].
  ///
  /// Page 1: Full Prepress Sheet with 3mm Bleed, 70x120mm Trim Box, and Printer Crop Marks.
  /// Page 2: Direct 76x126mm Bleed-box trimmed card.
  static Future<Uint8List> generatePrintReadyPdf({
    required TarotCard card,
    required bool isDark,
    bool includeCropMarks = true,
  }) async {
    final doc = pw.Document(
      title: 'Tarot Forge - ${card.name}',
      author: 'Tarot Forge Prepress Engine',
    );

    // Resolve fonts for vector typography
    pw.Font fontCinzelBold;
    pw.Font fontCinzelRegular;
    pw.Font fontOutfit;
    try {
      fontCinzelBold = await PdfGoogleFonts.cinzelBold();
      fontCinzelRegular = await PdfGoogleFonts.cinzelRegular();
      fontOutfit = await PdfGoogleFonts.outfitRegular();
    } catch (_) {
      fontCinzelBold = pw.Font.helveticaBold();
      fontCinzelRegular = pw.Font.helvetica();
      fontOutfit = pw.Font.helvetica();
    }

    // Resolve image bytes
    pw.MemoryImage? cardImage;
    try {
      if (card.customImageBytes != null) {
        cardImage = pw.MemoryImage(card.customImageBytes!);
      } else if (card.assetImagePath != null && card.assetImagePath!.isNotEmpty) {
        final byteData = await rootBundle.load(card.assetImagePath!);
        cardImage = pw.MemoryImage(byteData.buffer.asUint8List());
      }
    } catch (_) {
      cardImage = null;
    }

    final template = CardTemplate.allTemplates.firstWhere(
      (t) => t.id == card.templateId,
      orElse: () => CardTemplate.allTemplates.first,
    );

    // Dimensions in PDF points (72 pt / inch; 1 mm = 72 / 25.4 pt)
    const mm = PdfPageFormat.mm;
    const trimWidthPt = TarotConstants.trimWidthMm * mm; // 70 mm
    const trimHeightPt = TarotConstants.trimHeightMm * mm; // 120 mm
    const bleedPt = TarotConstants.bleedMm * mm; // 3 mm
    const fullWidthPt = trimWidthPt + (bleedPt * 2); // 76 mm
    const fullHeightPt = trimHeightPt + (bleedPt * 2); // 126 mm

    // Slug margin for printer crop marks (6 mm margin outside bleed)
    const slugMarginPt = 6.0 * mm;
    const sheetWidthPt = fullWidthPt + (slugMarginPt * 2); // 88 mm
    const sheetHeightPt = fullHeightPt + (slugMarginPt * 2); // 138 mm

    final goldColor = isDark
        ? const PdfColor.fromInt(0xFFD4AF37)
        : const PdfColor.fromInt(0xFFB0821A);
    final bgColor = isDark
        ? const PdfColor.fromInt(0xFF140D24)
        : const PdfColor.fromInt(0xFFFAF7F0);

    // --- PAGE 1: Prepress Sheet with Crop Marks & Slug Info ---
    doc.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          sheetWidthPt,
          sheetHeightPt,
          marginAll: 0,
        ),
        build: (context) {
          return pw.Stack(
            children: [
              // Prepress background (white margin for press)
              pw.Container(color: PdfColors.white),

              // Technical Header / Metadata Slug
              pw.Positioned(
                top: 2 * mm,
                left: slugMarginPt,
                right: slugMarginPt,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TAROT FORGE - ${card.name} (${card.romanNumeral})',
                      style: pw.TextStyle(
                        font: fontCinzelBold,
                        fontSize: 5.5,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '70x120mm Trim | 3mm Bleed | 300 DPI Print-Ready',
                      style: pw.TextStyle(
                        font: fontOutfit,
                        fontSize: 5.0,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),

              // Bleed Box container (76 x 126 mm) centered on the sheet
              pw.Positioned(
                left: slugMarginPt,
                top: slugMarginPt,
                child: pw.SizedBox(
                  width: fullWidthPt,
                  height: fullHeightPt,
                  child: _buildCardContent(
                    card: card,
                    template: template,
                    image: cardImage,
                    isDark: isDark,
                    goldColor: goldColor,
                    bgColor: bgColor,
                    fontCinzelBold: fontCinzelBold,
                    fontCinzelRegular: fontCinzelRegular,
                    fontOutfit: fontOutfit,
                    bleedPt: bleedPt,
                    trimWidthPt: trimWidthPt,
                    trimHeightPt: trimHeightPt,
                  ),
                ),
              ),

              // Printer Crop Marks (Trim Box Crosshairs)
              if (includeCropMarks)
                _buildCropMarks(
                  slugMarginPt: slugMarginPt,
                  bleedPt: bleedPt,
                  trimWidthPt: trimWidthPt,
                  trimHeightPt: trimHeightPt,
                  sheetWidthPt: sheetWidthPt,
                  sheetHeightPt: sheetHeightPt,
                ),

              // Technical Footer / CMYK Density Targets
              pw.Positioned(
                bottom: 2 * mm,
                left: slugMarginPt,
                right: slugMarginPt,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'CMYK CALIBRATION TARGET',
                      style: pw.TextStyle(
                        font: fontOutfit,
                        fontSize: 4.5,
                        color: PdfColors.grey500,
                      ),
                    ),
                    pw.Row(
                      children: [
                        _buildColorPatch(const PdfColor.fromInt(0xFF00FFFF)), // Cyan
                        _buildColorPatch(const PdfColor.fromInt(0xFFFF00FF)), // Magenta
                        _buildColorPatch(const PdfColor.fromInt(0xFFFFFF00)), // Yellow
                        _buildColorPatch(PdfColors.black),
                        _buildColorPatch(const PdfColor.fromInt(0xFFD4AF37)), // Gold
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // --- PAGE 2: Exact Bleed Box Page (76 x 126 mm, no slug) ---
    doc.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(
          fullWidthPt,
          fullHeightPt,
          marginAll: 0,
        ),
        build: (context) {
          return _buildCardContent(
            card: card,
            template: template,
            image: cardImage,
            isDark: isDark,
            goldColor: goldColor,
            bgColor: bgColor,
            fontCinzelBold: fontCinzelBold,
            fontCinzelRegular: fontCinzelRegular,
            fontOutfit: fontOutfit,
            bleedPt: bleedPt,
            trimWidthPt: trimWidthPt,
            trimHeightPt: trimHeightPt,
          );
        },
      ),
    );

    return doc.save();
  }

  /// Generates a multi-page print-ready PDF for an entire collection of [TarotCard]s.
  /// Supports optional double-sided (duplex) pages incorporating [cardBack].
  static Future<Uint8List> generateBatchPrintReadyPdf({
    required List<TarotCard> cards,
    CardBackDesign cardBack = const CardBackDesign(),
    required bool isDark,
    bool includeCropMarks = true,
    bool includeCardBacks = false,
  }) async {
    final doc = pw.Document(
      title: 'Tarot Forge - Bộ Bài ${cards.length} Lá',
      author: 'Tarot Forge Prepress Batch Engine',
    );

    // Resolve fonts once
    pw.Font fontCinzelBold;
    pw.Font fontCinzelRegular;
    pw.Font fontOutfit;
    try {
      fontCinzelBold = await PdfGoogleFonts.cinzelBold();
      fontCinzelRegular = await PdfGoogleFonts.cinzelRegular();
      fontOutfit = await PdfGoogleFonts.outfitRegular();
    } catch (_) {
      fontCinzelBold = pw.Font.helveticaBold();
      fontCinzelRegular = pw.Font.helvetica();
      fontOutfit = pw.Font.helvetica();
    }

    const mm = PdfPageFormat.mm;
    const trimWidthPt = TarotConstants.trimWidthMm * mm;
    const trimHeightPt = TarotConstants.trimHeightMm * mm;
    const bleedPt = TarotConstants.bleedMm * mm;
    const fullWidthPt = trimWidthPt + (bleedPt * 2);
    const fullHeightPt = trimHeightPt + (bleedPt * 2);
    const slugMarginPt = 6.0 * mm;
    const sheetWidthPt = fullWidthPt + (slugMarginPt * 2);
    const sheetHeightPt = fullHeightPt + (slugMarginPt * 2);

    final goldColor = isDark
        ? const PdfColor.fromInt(0xFFD4AF37)
        : const PdfColor.fromInt(0xFFB0821A);
    final bgColor = isDark
        ? const PdfColor.fromInt(0xFF140D24)
        : const PdfColor.fromInt(0xFFFAF7F0);

    for (int i = 0; i < cards.length; i++) {
      final card = cards[i];
      final template = CardTemplate.allTemplates.firstWhere(
        (t) => t.id == card.templateId,
        orElse: () => CardTemplate.allTemplates.first,
      );

      pw.MemoryImage? cardImage;
      try {
        if (card.customImageBytes != null) {
          cardImage = pw.MemoryImage(card.customImageBytes!);
        } else if (card.assetImagePath != null && card.assetImagePath!.isNotEmpty) {
          final byteData = await rootBundle.load(card.assetImagePath!);
          cardImage = pw.MemoryImage(byteData.buffer.asUint8List());
        }
      } catch (_) {
        cardImage = null;
      }

      // 1. FRONT PAGE (Mặt trước)
      doc.addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(
            sheetWidthPt,
            sheetHeightPt,
            marginAll: 0,
          ),
          build: (context) {
            return pw.Stack(
              children: [
                pw.Container(color: PdfColors.white),
                // Slug Header
                pw.Positioned(
                  top: 2 * mm,
                  left: slugMarginPt,
                  right: slugMarginPt,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'LÁ ${i + 1}/${cards.length} - ${card.name} (${card.romanNumeral}) [MẶT TRƯỚC]',
                        style: pw.TextStyle(
                          font: fontCinzelBold,
                          fontSize: 5.5,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.Text(
                        '70x120mm Trim | 3mm Bleed | 300 DPI Print-Ready',
                        style: pw.TextStyle(
                          font: fontOutfit,
                          fontSize: 5.0,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bleed Box
                pw.Positioned(
                  left: slugMarginPt,
                  top: slugMarginPt,
                  child: pw.SizedBox(
                    width: fullWidthPt,
                    height: fullHeightPt,
                    child: _buildCardContent(
                      card: card,
                      template: template,
                      image: cardImage,
                      isDark: isDark,
                      goldColor: goldColor,
                      bgColor: bgColor,
                      fontCinzelBold: fontCinzelBold,
                      fontCinzelRegular: fontCinzelRegular,
                      fontOutfit: fontOutfit,
                      bleedPt: bleedPt,
                      trimWidthPt: trimWidthPt,
                      trimHeightPt: trimHeightPt,
                    ),
                  ),
                ),
                // Crop marks
                if (includeCropMarks)
                  _buildCropMarks(
                    slugMarginPt: slugMarginPt,
                    bleedPt: bleedPt,
                    trimWidthPt: trimWidthPt,
                    trimHeightPt: trimHeightPt,
                    sheetWidthPt: sheetWidthPt,
                    sheetHeightPt: sheetHeightPt,
                  ),
              ],
            );
          },
        ),
      );

      // 2. DUPLEX BACK PAGE (Mặt sau tương ứng nếu bật in hai mặt)
      if (includeCardBacks) {
        doc.addPage(
          pw.Page(
            pageFormat: const PdfPageFormat(
              sheetWidthPt,
              sheetHeightPt,
              marginAll: 0,
            ),
            build: (context) {
              return pw.Stack(
                children: [
                  pw.Container(color: PdfColors.white),
                  // Slug Header
                  pw.Positioned(
                    top: 2 * mm,
                    left: slugMarginPt,
                    right: slugMarginPt,
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'LÁ ${i + 1}/${cards.length} - MẶT SAU (${cardBack.pattern.displayName})',
                          style: pw.TextStyle(
                            font: fontCinzelBold,
                            fontSize: 5.5,
                            color: PdfColors.grey700,
                          ),
                        ),
                        pw.Text(
                          'DUPLEX PRINT READY • ĐỐI XỨNG TUYỆT ĐỐI',
                          style: pw.TextStyle(
                            font: fontOutfit,
                            fontSize: 5.0,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bleed Box for Card Back
                  pw.Positioned(
                    left: slugMarginPt,
                    top: slugMarginPt,
                    child: pw.SizedBox(
                      width: fullWidthPt,
                      height: fullHeightPt,
                      child: _buildCardBackContent(
                        cardBack: cardBack,
                        isDark: isDark,
                        goldColor: goldColor,
                        bgColor: bgColor,
                        fontCinzelBold: fontCinzelBold,
                        bleedPt: bleedPt,
                        trimWidthPt: trimWidthPt,
                        trimHeightPt: trimHeightPt,
                      ),
                    ),
                  ),
                  if (includeCropMarks)
                    _buildCropMarks(
                      slugMarginPt: slugMarginPt,
                      bleedPt: bleedPt,
                      trimWidthPt: trimWidthPt,
                      trimHeightPt: trimHeightPt,
                      sheetWidthPt: sheetWidthPt,
                      sheetHeightPt: sheetHeightPt,
                    ),
                ],
              );
            },
          ),
        );
      }
    }

    return doc.save();
  }

  /// Builds the 76x126mm bleed canvas content for card front.
  static pw.Widget _buildCardContent({
    required TarotCard card,
    required CardTemplate template,
    required pw.MemoryImage? image,
    required bool isDark,
    required PdfColor goldColor,
    required PdfColor bgColor,
    required pw.Font fontCinzelBold,
    required pw.Font fontCinzelRegular,
    required pw.Font fontOutfit,
    required double bleedPt,
    required double trimWidthPt,
    required double trimHeightPt,
  }) {
    return pw.Container(
      color: bgColor,
      child: pw.Stack(
        children: [
          // Background / Artwork extending into bleed
          if (image != null)
            template.isFullBleedImage
                ? pw.Positioned.fill(
                    child: pw.Image(image, fit: pw.BoxFit.cover),
                  )
                : pw.Positioned(
                    left: bleedPt + 14,
                    right: bleedPt + 14,
                    top: bleedPt + 36,
                    bottom: bleedPt + 52,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: goldColor, width: 0.8),
                      ),
                      child: pw.Image(image, fit: pw.BoxFit.cover),
                    ),
                  ),

          // Vector Ornate Frame within trim boundaries
          pw.Positioned(
            left: bleedPt + 6,
            right: bleedPt + 6,
            top: bleedPt + 6,
            bottom: bleedPt + 6,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: goldColor, width: 1.5),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(3),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: goldColor, width: 0.6),
                  ),
                ),
              ),
            ),
          ),

          // Header: Roman Numeral
          pw.Positioned(
            top: bleedPt + 14,
            left: bleedPt + 16,
            right: bleedPt + 16,
            child: pw.Center(
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: pw.BoxDecoration(
                  color: bgColor,
                  border: pw.Border.all(color: goldColor, width: 0.8),
                ),
                child: pw.Text(
                  card.romanNumeral,
                  style: pw.TextStyle(
                    font: fontCinzelBold,
                    fontSize: 11,
                    color: goldColor,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ),

          // Footer: Card Title and Subtitle
          pw.Positioned(
            bottom: bleedPt + 12,
            left: bleedPt + 10,
            right: bleedPt + 10,
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: pw.BoxDecoration(
                color: bgColor,
                border: pw.Border.all(color: goldColor, width: 1.0),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    card.name,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: fontCinzelBold,
                      fontSize: 10.5,
                      color: goldColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (card.subtitle.isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(
                      card.subtitle,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        font: fontOutfit,
                        fontSize: 6.5,
                        color: isDark ? PdfColors.grey400 : PdfColors.grey700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the 76x126mm bleed canvas content for card back.
  static pw.Widget _buildCardBackContent({
    required CardBackDesign cardBack,
    required bool isDark,
    required PdfColor goldColor,
    required PdfColor bgColor,
    required pw.Font fontCinzelBold,
    required double bleedPt,
    required double trimWidthPt,
    required double trimHeightPt,
  }) {
    final backBgColor = isDark
        ? const PdfColor.fromInt(0xFF0F0B1E)
        : const PdfColor.fromInt(0xFF140D24);

    return pw.Container(
      color: backBgColor,
      child: pw.Stack(
        children: [
          // Double Vector Ornate Borders
          pw.Positioned(
            left: bleedPt + 6,
            right: bleedPt + 6,
            top: bleedPt + 6,
            bottom: bleedPt + 6,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: goldColor, width: 1.5),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: goldColor, width: 0.7),
                  ),
                ),
              ),
            ),
          ),

          // Central Sacred Geometry Emblem
          pw.Center(
            child: pw.Container(
              width: 100,
              height: 100,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                border: pw.Border.all(color: goldColor, width: 1.2),
              ),
              child: pw.Center(
                child: pw.Container(
                  width: 70,
                  height: 70,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: goldColor, width: 0.8),
                  ),
                  child: pw.Center(
                    child: pw.Container(
                      width: 40,
                      height: 40,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: goldColor, width: 1.4),
                      ),
                      child: pw.Center(
                        child: pw.Container(
                          width: 14,
                          height: 14,
                          decoration: pw.BoxDecoration(
                            color: goldColor,
                            shape: pw.BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top Inscription
          pw.Positioned(
            top: bleedPt + 14,
            left: bleedPt + 14,
            right: bleedPt + 14,
            child: pw.Center(
              child: pw.Text(
                'TAROT FORGE',
                style: pw.TextStyle(
                  font: fontCinzelBold,
                  fontSize: 7.5,
                  color: goldColor,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),

          // Bottom Symmetrical Inscription
          pw.Positioned(
            bottom: bleedPt + 14,
            left: bleedPt + 14,
            right: bleedPt + 14,
            child: pw.Center(
              child: pw.Text(
                'TAROT FORGE',
                style: pw.TextStyle(
                  font: fontCinzelBold,
                  fontSize: 7.5,
                  color: goldColor,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds standard printer crop crosshair marks positioned 1pt outside the trim boundaries.
  static pw.Widget _buildCropMarks({
    required double slugMarginPt,
    required double bleedPt,
    required double trimWidthPt,
    required double trimHeightPt,
    required double sheetWidthPt,
    required double sheetHeightPt,
  }) {
    const mm = PdfPageFormat.mm;
    final trimLeft = slugMarginPt + bleedPt;
    final trimTop = slugMarginPt + bleedPt;
    final trimRight = trimLeft + trimWidthPt;
    final trimBottom = trimTop + trimHeightPt;

    final markLength = 4.0 * mm;
    const markGap = 1.0;

    return pw.Stack(
      children: [
        // Top-Left Corner Marks
        pw.Positioned(
          left: trimLeft,
          top: trimTop - markGap - markLength,
          child: _verticalLine(markLength),
        ),
        pw.Positioned(
          left: trimLeft - markGap - markLength,
          top: trimTop,
          child: _horizontalLine(markLength),
        ),

        // Top-Right Corner Marks
        pw.Positioned(
          left: trimRight,
          top: trimTop - markGap - markLength,
          child: _verticalLine(markLength),
        ),
        pw.Positioned(
          left: trimRight + markGap,
          top: trimTop,
          child: _horizontalLine(markLength),
        ),

        // Bottom-Left Corner Marks
        pw.Positioned(
          left: trimLeft,
          top: trimBottom + markGap,
          child: _verticalLine(markLength),
        ),
        pw.Positioned(
          left: trimLeft - markGap - markLength,
          top: trimBottom,
          child: _horizontalLine(markLength),
        ),

        // Bottom-Right Corner Marks
        pw.Positioned(
          left: trimRight,
          top: trimBottom + markGap,
          child: _verticalLine(markLength),
        ),
        pw.Positioned(
          left: trimRight + markGap,
          top: trimBottom,
          child: _horizontalLine(markLength),
        ),
      ],
    );
  }

  static pw.Widget _verticalLine(double length) {
    return pw.SizedBox(
      width: 0.5,
      height: length,
      child: pw.Container(color: PdfColors.black),
    );
  }

  static pw.Widget _horizontalLine(double length) {
    return pw.SizedBox(
      width: length,
      height: 0.5,
      child: pw.Container(color: PdfColors.black),
    );
  }

  static pw.Widget _buildColorPatch(PdfColor color) {
    return pw.Container(
      width: 8,
      height: 4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 1.5),
      color: color,
    );
  }
}
