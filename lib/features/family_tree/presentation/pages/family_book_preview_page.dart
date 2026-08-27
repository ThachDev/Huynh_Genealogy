import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/models/family_book_config.dart';
import '../../domain/services/family_book_pdf_service.dart';

class FamilyBookPreviewPage extends StatefulWidget {
  const FamilyBookPreviewPage({
    super.key,
    required this.members,
    required this.config,
  });

  final List<MemberEntity> members;
  final FamilyBookConfig config;

  @override
  State<FamilyBookPreviewPage> createState() => _FamilyBookPreviewPageState();
}

class _FamilyBookPreviewPageState extends State<FamilyBookPreviewPage> {
  final PageController _pageController = PageController();
  final FamilyBookPdfService _pdfService = FamilyBookPdfService();

  Uint8List? _pdfBytes;
  List<Uint8List> _pageImages = [];
  bool _isLoading = true;
  bool _isRasterizingMore = false;
  int _currentPage = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateAndRasterizePdf();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _generateAndRasterizePdf() async {
    setState(() {
      _isLoading = true;
      _isRasterizingMore = false;
      _errorMessage = null;
      _pageImages = [];
    });

    try {
      final bytes = await _pdfService.generateBookPdf(
        members: widget.members,
        config: widget.config,
      );
      _pdfBytes = bytes;

      final List<Uint8List> images = [];

      // ── PROGRESSIVE STREAMING: Hiển thị ngay trang 1 không phải chờ 100% tài liệu ──
      await for (final page in Printing.raster(bytes, dpi: 120)) {
        final pngBytes = await page.toPng();
        images.add(pngBytes);

        if (mounted) {
          setState(() {
            _pageImages = List.from(images);
            _isLoading = false;
            _isRasterizingMore = true;
          });
        }
      }

      if (mounted) {
        setState(() {
          _isRasterizingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Không thể hiển thị bản xem trước: $e';
          _isLoading = false;
          _isRasterizingMore = false;
        });
      }
    }
  }

  String get _fileName =>
      '${widget.config.bookTitle.replaceAll(" ", "_")}_${DateTime.now().year}.pdf';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.familyBookPreviewTitle,
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
                  onLayout: (_) => _pdfBytes!,
                  name: _fileName,
                );
              },
            ),
          ],
        ],
      ),
      body: AppBackgroundBody(
        child: _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
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
              l10n.familyBookRendering,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.familyBookPleaseWait,
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
              Icon(LucideIcons.alertCircle, size: 48, color: context.error),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 14,
                  color: context.error,
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: l10n.retryButton,
                size: AppButtonSize.small,
                prefixIcon: const Icon(LucideIcons.rotateCcw, size: 14),
                onPressed: _generateAndRasterizePdf,
              ),
            ],
          ),
        ),
      );
    }

    if (_pageImages.isEmpty) {
      return Center(child: Text(l10n.noPageData));
    }

    return SafeArea(
      child: Stack(
        children: [
          // ── HORIZONTAL BOOK PAGEVIEW ──
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: _pageImages.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 72),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: context.accent.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: Image.memory(
                            _pageImages[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── FLOATING BOTTOM CONTROLLER BAR ──
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: context.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.chevronLeft, size: 18),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      color: _currentPage > 0
                          ? context.textPrimary
                          : context.textSecondary.withValues(alpha: 0.3),
                      onPressed: _currentPage > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Trang ${_currentPage + 1} / ${_pageImages.length}',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                          if (_isRasterizingMore) ...[
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: context.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(LucideIcons.chevronRight, size: 18),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      color: _currentPage < _pageImages.length - 1
                          ? context.textPrimary
                          : context.textSecondary.withValues(alpha: 0.3),
                      onPressed: _currentPage < _pageImages.length - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeOutCubic,
                              );
                            }
                          : null,
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
