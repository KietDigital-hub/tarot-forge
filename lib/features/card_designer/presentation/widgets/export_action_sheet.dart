import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../../../../core/constants/tarot_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/card_designer_provider.dart';
import '../../services/pdf_export_service.dart';

/// Modal bottom sheet displaying prepress specifications and providing
/// options to generate, preview, print, and save the print-ready PDF.
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

  Future<void> _handlePreviewAndPrint() async {
    setState(() => _isExporting = true);
    try {
      final card = ref.read(cardDesignerProvider);
      final pdfBytes = await PdfExportService.generatePrintReadyPdf(
        card: card,
        isDark: widget.isDark,
        includeCropMarks: _includeCropMarks,
      );

      if (mounted) {
        setState(() => _isExporting = false);
        Navigator.of(context).pop();

        await Printing.layoutPdf(
          name: 'TarotForge_${card.name.replaceAll(' ', '_')}.pdf',
          onLayout: (format) async => pdfBytes,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export error: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _handleShareSavePdf() async {
    setState(() => _isExporting = true);
    try {
      final card = ref.read(cardDesignerProvider);
      final pdfBytes = await PdfExportService.generatePrintReadyPdf(
        card: card,
        isDark: widget.isDark,
        includeCropMarks: _includeCropMarks,
      );

      if (mounted) {
        setState(() => _isExporting = false);
        Navigator.of(context).pop();

        final filename =
            'TarotForge_${card.name.replaceAll(' ', '_')}_300DPI.pdf';
        await Printing.sharePdf(bytes: pdfBytes, filename: filename);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save error: $e'),
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

    return Padding(
      padding: const EdgeInsets.all(22.0),
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
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.print_outlined, color: gold, size: 24),
              const SizedBox(width: 10),
              Text(
                'PRINT-READY EXPORT',
                style: AppTypography.screenTitle(isDark: isDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Generate industry-compliant prepress files calibrated for commercial press or fine art printing.',
            style: AppTypography.body(isDark: isDark, fontSize: 13),
          ),
          const SizedBox(height: 18),

          // Technical specifications box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: gold.withValues(alpha: 0.35)),
            ),
            child: Column(
              children: [
                _buildSpecRow('Standard Card Size', '${TarotConstants.trimWidthMm.toInt()} x ${TarotConstants.trimHeightMm.toInt()} mm (Rider-Waite)', isDark),
                const Divider(height: 14, thickness: 0.5),
                _buildSpecRow('Bleed Margin', '${TarotConstants.bleedMm.toInt()} mm on all sides', isDark),
                const Divider(height: 14, thickness: 0.5),
                _buildSpecRow('Bleed Canvas', '${TarotConstants.fullWidthWithBleedMm.toInt()} x ${TarotConstants.fullHeightWithBleedMm.toInt()} mm', isDark),
                const Divider(height: 14, thickness: 0.5),
                _buildSpecRow('Target Resolution', '${TarotConstants.printDpi} DPI (${TarotConstants.fullWidthPx300Dpi} x ${TarotConstants.fullHeightPx300Dpi} px)', isDark),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Crop marks toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Include Printer Crop Marks',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            subtitle: Text(
              'Corner crosshairs pointing exactly to 70x120mm trim edge',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11.5,
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
              ),
            ),
            value: _includeCropMarks,
            activeThumbColor: gold,
            onChanged: (val) => setState(() => _includeCropMarks = val),
          ),

          const SizedBox(height: 20),

          if (_isExporting)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: gold),
                    const SizedBox(height: 12),
                    Text(
                      'Rendering 300 DPI Prepress PDF...',
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 12,
                        color: gold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handlePreviewAndPrint,
                icon: const Icon(Icons.picture_as_pdf, size: 20),
                label: const Text('PREVIEW & PRINT PDF'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleShareSavePdf,
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text('SAVE / SHARE PDF FILE'),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
