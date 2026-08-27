import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/models/family_tree_poster_config.dart';
import '../../domain/services/family_tree_poster_pdf_service.dart';

class FamilyTreePosterPreviewPage extends StatefulWidget {
  const FamilyTreePosterPreviewPage({
    super.key,
    required this.members,
    required this.config,
  });

  final List<MemberEntity> members;
  final FamilyTreePosterConfig config;

  @override
  State<FamilyTreePosterPreviewPage> createState() =>
      _FamilyTreePosterPreviewPageState();
}

class _FamilyTreePosterPreviewPageState
    extends State<FamilyTreePosterPreviewPage> {
  final TransformationController _transformationController =
      TransformationController();
  final FamilyTreePosterPdfService _pdfService = FamilyTreePosterPdfService();

  Uint8List? _pdfBytes;
  Uint8List? _posterImage;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateAndRasterizePoster();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _generateAndRasterizePoster() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bytes = await _pdfService.generatePosterPdf(
        members: widget.members,
        config: widget.config,
      );
      _pdfBytes = bytes;

      final dpi = _getSafeRasterDpi(widget.config.paperSize);
      await for (final page in Printing.raster(bytes, dpi: dpi)) {
        final pngBytes = await page.toPng();
        if (mounted) {
          setState(() {
            _posterImage = pngBytes;
            _isLoading = false;
          });
        }
        break; // Tranh Phả đồ chỉ có 1 trang duy nhất
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Không thể dựng bản xem trước: $e';
          _isLoading = false;
        });
      }
    }
  }

  String get _fileName =>
      '${widget.config.title.replaceAll(" ", "_")}_${widget.config.paperSize.name.toUpperCase()}.pdf';

  static double _getSafeRasterDpi(PosterPaperSize size) {
    switch (size) {
      case PosterPaperSize.a0:
        return 36.0;
      case PosterPaperSize.a1:
        return 48.0;
      case PosterPaperSize.a2:
        return 72.0;
      case PosterPaperSize.a3:
        return 96.0;
      case PosterPaperSize.a4:
        return 130.0;
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sizeName = widget.config.paperSize.name.toUpperCase();
    final orientName =
        widget.config.orientation == PosterOrientation.landscape
            ? 'Khổ ngang'
            : 'Khổ dọc';

    return Scaffold(
      appBar: AppAppBar(
        title: 'Xem Trước Tranh Phả Đồ',
        actions: [
          if (_pdfBytes != null) ...[
            IconButton(
              icon: const Icon(LucideIcons.share2, size: 20),
              tooltip: l10n.familyBookSharePdf,
              onPressed: () async {
                await Printing.sharePdf(
                  bytes: _pdfBytes!,
                  filename: _fileName,
                );
              },
            ),
            IconButton(
              icon: const Icon(LucideIcons.printer, size: 20),
              tooltip: l10n.familyBookPrint,
              onPressed: () async {
                await Printing.layoutPdf(
                  onLayout: (format) async => _pdfBytes!,
                  name: _fileName,
                );
              },
            ),
          ],
          const SizedBox(width: 4),
        ],
      ),
      body: AppBackgroundBody(
        enableMaxWidth: false,
        child: _buildBody(l10n, sizeName, orientName),
      ),
    );
  }

  Widget _buildBody(
      AppLocalizations l10n, String sizeName, String orientName) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              color: context.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Đang dựng tranh Phả Đồ $sizeName...',
              style: GoogleFonts.beVietnamPro(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Độ nét cao chuẩn in ấn',
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.alertTriangle, size: 48, color: context.error),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: l10n.retryButton,
                prefixIcon: const Icon(LucideIcons.rotateCcw, size: 16),
                onPressed: _generateAndRasterizePoster,
              ),
            ],
          ),
        ),
      );
    }

    if (_posterImage == null) {
      return const Center(child: Text('Không có dữ liệu tranh'));
    }

    return SafeArea(
      child: Stack(
        children: [
          // ── INTERACTIVE VIEWER (DEEP ZOOM) ──
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.3,
              maxScale: 8.0,
              boundaryMargin: const EdgeInsets.all(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _posterImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── FLOATING CONTROLLER BAR ──
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: context.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: context.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        sizeName,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      orientName,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 1,
                      height: 16,
                      color: context.accent.withValues(alpha: 0.3),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(LucideIcons.maximize2, size: 16),
                      tooltip: 'Vừa màn hình',
                      visualDensity: VisualDensity.compact,
                      onPressed: _resetZoom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
