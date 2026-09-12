import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../deck_manager/presentation/providers/deck_provider.dart';
import '../providers/card_designer_provider.dart';
import '../../domain/models/tarot_card.dart';
import '../../services/pdf_export_service.dart';

enum ExportScope {
  currentCard,
  majorArcana,
  customizedOnly,
  fullDeck,
}

extension ExportScopeExtension on ExportScope {
  String get title {
    switch (this) {
      case ExportScope.currentCard:
        return 'Lá Hiện Tại (1 lá)';
      case ExportScope.majorArcana:
        return 'Bộ Ẩn Chính (22 lá)';
      case ExportScope.customizedOnly:
        return 'Các Lá Đã Tùy Biến';
      case ExportScope.fullDeck:
        return 'Trọn Bộ Bài (78 lá)';
    }
  }

  String get subtitle {
    switch (this) {
      case ExportScope.currentCard:
        return 'Xuất 1 file gồm trang Prepress và trang Bleed';
      case ExportScope.majorArcana:
        return 'Từ 0 - Kẻ Khờ đến XXI - Thế Giới';
      case ExportScope.customizedOnly:
        return 'Chỉ xuất các lá đã có tranh hoặc văn bản chỉnh sửa';
      case ExportScope.fullDeck:
        return 'Toàn bộ 22 Ẩn chính + 56 Ẩn phụ';
    }
  }
}

/// Modal bottom sheet displaying prepress specifications and providing
/// options to generate single or batch print-ready PDFs (300 DPI).
class ExportActionSheet extends ConsumerStatefulWidget {
  final bool isDark;

  const ExportActionSheet({super.key, required this.isDark});

  static Future<void> show(BuildContext context, bool isDark) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExportActionSheet(isDark: isDark),
    );
  }

  @override
  ConsumerState<ExportActionSheet> createState() => _ExportActionSheetState();
}

class _ExportActionSheetState extends ConsumerState<ExportActionSheet> {
  bool _isExporting = false;
  bool _includeCropMarks = true;
  bool _includeCardBacks = false;
  ExportScope _scope = ExportScope.currentCard;

  List<TarotCard> _resolveCardsToExport() {
    final deck = ref.read(deckProvider);
    final currentCard = ref.read(cardDesignerProvider);

    switch (_scope) {
      case ExportScope.currentCard:
        return [currentCard];
      case ExportScope.majorArcana:
        return deck.majorArcana;
      case ExportScope.customizedOnly:
        final list = deck.customizedCards;
        return list.isEmpty ? [currentCard] : list;
      case ExportScope.fullDeck:
        return deck.cards;
    }
  }

  Future<void> _handlePreviewAndPrint() async {
    setState(() => _isExporting = true);
    try {
      final cards = _resolveCardsToExport();
      final cardBack = ref.read(cardBackProvider);

      final pdfBytes = cards.length == 1 && _scope == ExportScope.currentCard
          ? await PdfExportService.generatePrintReadyPdf(
              card: cards.first,
              isDark: widget.isDark,
              includeCropMarks: _includeCropMarks,
            )
          : await PdfExportService.generateBatchPrintReadyPdf(
              cards: cards,
              cardBack: cardBack,
              isDark: widget.isDark,
              includeCropMarks: _includeCropMarks,
              includeCardBacks: _includeCardBacks,
            );

      if (mounted) {
        setState(() => _isExporting = false);
        Navigator.of(context).pop();

        final fileName = cards.length == 1
            ? 'TarotForge_${cards.first.name.replaceAll(' ', '_')}.pdf'
            : 'TarotForge_BoBai_${cards.length}La.pdf';

        await Printing.layoutPdf(
          name: fileName,
          onLayout: (format) async => pdfBytes,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xuất file: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _handleShareSavePdf() async {
    setState(() => _isExporting = true);
    try {
      final cards = _resolveCardsToExport();
      final cardBack = ref.read(cardBackProvider);

      final pdfBytes = cards.length == 1 && _scope == ExportScope.currentCard
          ? await PdfExportService.generatePrintReadyPdf(
              card: cards.first,
              isDark: widget.isDark,
              includeCropMarks: _includeCropMarks,
            )
          : await PdfExportService.generateBatchPrintReadyPdf(
              cards: cards,
              cardBack: cardBack,
              isDark: widget.isDark,
              includeCropMarks: _includeCropMarks,
              includeCardBacks: _includeCardBacks,
            );

      if (mounted) {
        setState(() => _isExporting = false);
        Navigator.of(context).pop();

        final filename = cards.length == 1
            ? 'TarotForge_${cards.first.name.replaceAll(' ', '_')}_300DPI.pdf'
            : 'TarotForge_BoBai_${cards.length}La_300DPI.pdf';

        await Printing.sharePdf(bytes: pdfBytes, filename: filename);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi lưu file: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final gold = isDark ? AppColors.goldPrimary : AppColors.lightGoldPrimary;
    final deck = ref.watch(deckProvider);
    final customizedCount = deck.customizedCount;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
      child: SingleChildScrollView(
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

            // Header Title
            Row(
              children: [
                Icon(Icons.print_outlined, color: gold, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'XUẤT FILE IN ẤN CÔNG NGHIỆP',
                        style: AppTypography.screenTitle(isDark: isDark),
                      ),
                      Text(
                        'PDF Vector 300 DPI • Khổ 70 x 120 mm + 3mm Bleed',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 1. Export Scope Selection
            Text(
              'PHẠM VI XUẤT BẢN',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: gold,
              ),
            ),
            const SizedBox(height: 8),

            ...ExportScope.values.map((scope) {
              final isSelected = _scope == scope;
              String extraInfo = '';
              if (scope == ExportScope.customizedOnly) {
                extraInfo = ' ($customizedCount lá)';
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? gold.withValues(alpha: isDark ? 0.2 : 0.12)
                      : (isDark
                          ? AppColors.darkSurfaceVariant
                          : AppColors.lightSurfaceVariant),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? gold : Colors.transparent,
                  ),
                ),
                // ignore: deprecated_member_use
                child: RadioListTile<ExportScope>(
                  value: scope,
                  // ignore: deprecated_member_use
                  groupValue: _scope,
                  activeColor: gold,
                  dense: true,
                  // ignore: deprecated_member_use
                  onChanged: (val) {
                    if (val != null) setState(() => _scope = val);
                  },
                  title: Text(
                    '${scope.title}$extraInfo',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  subtitle: Text(
                    scope.subtitle,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 14),

            // 2. Prepress Print Options
            Text(
              'TÙY CHỌN BÌNH TRANG (IMPOSITION)',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: gold,
              ),
            ),
            const SizedBox(height: 6),

            // Toggle Crop Marks
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeThumbColor: gold,
              title: Text(
                'Dấu chữ thập & đường xén (Crop Marks)',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                'Tạo 4 góc chữ thập chuẩn nhà in offset/laser công nghiệp',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              value: _includeCropMarks,
              onChanged: (val) => setState(() => _includeCropMarks = val),
            ),

            // Toggle Duplex (In 2 mặt kèm mặt sau)
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeThumbColor: gold,
              title: Text(
                'In hai mặt (Duplex) kèm Mặt Sau',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                'Mỗi trang mặt trước đi kèm 1 trang hoa văn mặt sau tương ứng',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
              value: _includeCardBacks,
              onChanged: (val) => setState(() => _includeCardBacks = val),
            ),
            const SizedBox(height: 16),

            // Export Actions
            if (_isExporting)
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: gold),
                    const SizedBox(height: 12),
                    Text(
                      'Đang tạo tài liệu in ấn PDF độ phân giải cao...',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: gold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _handleShareSavePdf,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('LƯU / CHIA SẺ'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: gold.withValues(alpha: 0.6)),
                        foregroundColor: gold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handlePreviewAndPrint,
                      icon: const Icon(Icons.print_outlined, size: 18),
                      label: const Text('XEM & IN NGAY'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: gold,
                        foregroundColor:
                            isDark ? const Color(0xFF0D0D0D) : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
