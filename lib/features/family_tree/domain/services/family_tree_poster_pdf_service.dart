import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../entities/member_entity.dart';
import '../models/family_book_config.dart';
import '../models/family_tree_poster_config.dart';

class FamilyTreePosterPdfService {
  Future<Uint8List> generatePosterPdf({
    required List<MemberEntity> members,
    required FamilyTreePosterConfig config,
  }) async {
    final pdf = pw.Document();

    // 1. Tải font chữ hỗ trợ tiếng Việt
    final fontRegular = await PdfGoogleFonts.beVietnamProRegular();
    final fontBold = await PdfGoogleFonts.beVietnamProBold();
    final fontItalic = await PdfGoogleFonts.beVietnamProItalic();
    final fontBoldItalic = await PdfGoogleFonts.beVietnamProBoldItalic();

    final themeData = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
      boldItalic: fontBoldItalic,
    );

    // 2. Tính toán kích thước khổ giấy (A0 -> A4, Ngang / Dọc)
    final pageFormat = _getPageFormat(config.paperSize, config.orientation);
    final colors = _getThemeColors(config.posterTheme);

    // 2.1 Tải hình nền hoa văn
    final String? bgAssetPath =
        config.posterTheme == FamilyBookCoverTheme.darkRoyal
            ? 'assets/images/bgcard_dark.png'
            : config.posterTheme == FamilyBookCoverTheme.lightTraditional
                ? 'assets/images/bgcard_light.png'
                : null;

    Uint8List? bgImageBytes;
    if (bgAssetPath != null) {
      try {
        final byteData = await rootBundle.load(bgAssetPath);
        bgImageBytes = byteData.buffer.asUint8List();
      } catch (_) {}
    }

    // 3. Phân loại thành viên theo thế hệ
    final sortedMembers = List<MemberEntity>.from(members);
    sortedMembers.sort((a, b) {
      final genA = a.generation ?? 999;
      final genB = b.generation ?? 999;
      if (genA != genB) return genA.compareTo(genB);
      return a.id.compareTo(b.id);
    });

    final generationMap = <int, List<MemberEntity>>{};
    for (final m in sortedMembers) {
      final gen = m.generation ?? 1;
      if (gen < config.startGeneration) continue;
      if (config.endGeneration != null && gen > config.endGeneration!) continue;
      generationMap.putIfAbsent(gen, () => []).add(m);
    }

    final sortedGenerations = generationMap.keys.toList()..sort();
    final memberMap = {for (final m in members) m.id: m};

    // Scale padding & font theo kích thước khổ giấy
    final scaleFactor = _getScaleFactor(config.paperSize);

    // 4. Vẽ Tranh Phả Đồ 1 trang duy nhất
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        theme: themeData,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(
            fit: pw.StackFit.expand,
            children: [
              // Nền tranh
              if (bgImageBytes != null)
                pw.Image(
                  pw.MemoryImage(bgImageBytes),
                  fit: pw.BoxFit.cover,
                )
              else
                pw.Container(
                  color: colors.backgroundTint,
                ),

              // Khung viền mỹ thuật kép
              pw.Padding(
                padding: pw.EdgeInsets.all(16 * scaleFactor),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: colors.accent,
                      width: 2.0 * scaleFactor,
                    ),
                  ),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.all(6 * scaleFactor),
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: colors.primary,
                          width: 1.0 * scaleFactor,
                        ),
                      ),
                      padding: pw.EdgeInsets.symmetric(
                        horizontal: 20 * scaleFactor,
                        vertical: 16 * scaleFactor,
                      ),
                      child: pw.Column(
                        children: [
                          // ── TIÊU ĐỀ TRANH (TOP BANNER) ──
                          _buildTopBanner(config, colors, scaleFactor),
                          pw.SizedBox(height: 12 * scaleFactor),

                          // ── THÂN TRANH: CÂU ĐỐI 2 BÊN & CÂY PHẢ HỆ Ở GIỮA ──
                          pw.Expanded(
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                              children: [
                                // Câu đối vế trái
                                if (config.leftCouplet.trim().isNotEmpty)
                                  _buildCoupletBanner(
                                    config.leftCouplet.trim(),
                                    colors,
                                    scaleFactor,
                                    isLeft: true,
                                  ),

                                // Cây phả hệ ở trung tâm
                                pw.Expanded(
                                  child: pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(
                                      horizontal: 14 * scaleFactor,
                                    ),
                                    child: _buildTreeBody(
                                      sortedGenerations,
                                      generationMap,
                                      memberMap,
                                      config,
                                      colors,
                                      scaleFactor,
                                    ),
                                  ),
                                ),

                                // Câu đối vế phải
                                if (config.rightCouplet.trim().isNotEmpty)
                                  _buildCoupletBanner(
                                    config.rightCouplet.trim(),
                                    colors,
                                    scaleFactor,
                                    isLeft: false,
                                  ),
                              ],
                            ),
                          ),

                          // ── CHÂN TRANH: THÔNG TIN BIÊN SOẠN & LƯU HÀNH ──
                          pw.SizedBox(height: 10 * scaleFactor),
                          _buildBottomBanner(config, colors, scaleFactor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ── Helper Widgets ──

  static pw.Widget _buildTopBanner(
    FamilyTreePosterConfig config,
    _ThemeColors colors,
    double scale,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          'CỘI NGUỒN DÒNG TỘC',
          style: pw.TextStyle(
            fontSize: 10 * scale,
            fontWeight: pw.FontWeight.bold,
            color: colors.accent,
            letterSpacing: 2 * scale,
          ),
        ),
        pw.SizedBox(height: 4 * scale),
        pw.Text(
          config.title.toUpperCase(),
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 22 * scale,
            fontWeight: pw.FontWeight.bold,
            color: colors.primary,
            letterSpacing: 1.5 * scale,
          ),
        ),
        if (config.ancestorName.trim().isNotEmpty ||
            config.originAddress.trim().isNotEmpty) ...[
          pw.SizedBox(height: 3 * scale),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              if (config.ancestorName.trim().isNotEmpty)
                pw.Text(
                  config.ancestorName.trim(),
                  style: pw.TextStyle(
                    fontSize: 10.5 * scale,
                    fontWeight: pw.FontWeight.bold,
                    color: colors.textDark,
                  ),
                ),
              if (config.ancestorName.trim().isNotEmpty &&
                  config.originAddress.trim().isNotEmpty)
                pw.Text('  •  ',
                    style: pw.TextStyle(
                        fontSize: 10 * scale, color: colors.accent)),
              if (config.originAddress.trim().isNotEmpty)
                pw.Text(
                  config.originAddress.trim(),
                  style: pw.TextStyle(
                    fontSize: 9.5 * scale,
                    fontStyle: pw.FontStyle.italic,
                    color: colors.textMuted,
                  ),
                ),
            ],
          ),
        ],
        pw.SizedBox(height: 6 * scale),
        pw.Container(
          width: 140 * scale,
          height: 1.2 * scale,
          color: colors.accent,
        ),
      ],
    );
  }

  static pw.Widget _buildCoupletBanner(
    String text,
    _ThemeColors colors,
    double scale, {
    required bool isLeft,
  }) {
    // Tách từng chữ để xếp dọc trang trọng
    final words = text.split(' ');

    return pw.Container(
      width: 32 * scale,
      padding: pw.EdgeInsets.symmetric(
        vertical: 12 * scale,
        horizontal: 4 * scale,
      ),
      decoration: pw.BoxDecoration(
        color: colors.backgroundTint,
        border: pw.Border.all(color: colors.accent, width: 0.8 * scale),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4 * scale)),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: words
            .map(
              (w) => pw.Text(
                w.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 10 * scale,
                  fontWeight: pw.FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static pw.Widget _buildTreeBody(
    List<int> sortedGenerations,
    Map<int, List<MemberEntity>> generationMap,
    Map<int, MemberEntity> memberMap,
    FamilyTreePosterConfig config,
    _ThemeColors colors,
    double scale,
  ) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < sortedGenerations.length; i++) ...[
          _buildGenerationRow(
            sortedGenerations[i],
            generationMap[sortedGenerations[i]] ?? [],
            memberMap,
            config,
            colors,
            scale,
          ),
          if (i < sortedGenerations.length - 1)
            pw.Container(
              width: 1.5 * scale,
              height: 12 * scale,
              color: colors.accent,
            ),
        ],
      ],
    );
  }

  static pw.Widget _buildGenerationRow(
    int gen,
    List<MemberEntity> genMembers,
    Map<int, MemberEntity> memberMap,
    FamilyTreePosterConfig config,
    _ThemeColors colors,
    double scale,
  ) {
    final romanGen = _toRoman(gen);

    return pw.Row(
      children: [
        // Badge thế hệ bên trái
        pw.Container(
          width: 54 * scale,
          padding: pw.EdgeInsets.symmetric(
            horizontal: 6 * scale,
            vertical: 4 * scale,
          ),
          decoration: pw.BoxDecoration(
            color: colors.primary,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(3 * scale)),
          ),
          child: pw.Text(
            'ĐỜI $romanGen',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 8.5 * scale,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.SizedBox(width: 8 * scale),

        // Danh sách thành viên dàn đều
        pw.Expanded(
          child: pw.Wrap(
            alignment: pw.WrapAlignment.center,
            spacing: 6 * scale,
            runSpacing: 6 * scale,
            children: genMembers.map((m) {
              final parent =
                  m.parentId != null ? memberMap[m.parentId!] : null;
              final spouse =
                  m.spouseId != null ? memberMap[m.spouseId!] : null;

              return _buildPosterNodeCard(
                m,
                parent: parent,
                spouse: spouse,
                config: config,
                colors: colors,
                scale: scale,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPosterNodeCard(
    MemberEntity member, {
    MemberEntity? parent,
    MemberEntity? spouse,
    required FamilyTreePosterConfig config,
    required _ThemeColors colors,
    required double scale,
  }) {
    final isMale = member.gender == Gender.male;
    final borderColor = isMale ? colors.primary : colors.accent;

    return pw.Container(
      width: 120 * scale,
      padding: pw.EdgeInsets.all(5 * scale),
      decoration: pw.BoxDecoration(
        color: colors.backgroundTint,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4 * scale)),
        border: pw.Border.all(color: borderColor, width: 1.0 * scale),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          // Tên + Giới tính
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  member.fullName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 8.5 * scale,
                    fontWeight: pw.FontWeight.bold,
                    color: colors.primary,
                  ),
                  maxLines: 1,
                ),
              ),
              pw.Container(
                padding: pw.EdgeInsets.symmetric(
                  horizontal: 3.5 * scale,
                  vertical: 1.0 * scale,
                ),
                decoration: pw.BoxDecoration(
                  color: isMale ? colors.primary : colors.accent,
                  borderRadius:
                      pw.BorderRadius.all(pw.Radius.circular(2 * scale)),
                ),
                child: pw.Text(
                  isMale ? 'Nam' : 'Nữ',
                  style: pw.TextStyle(
                    fontSize: 5.5 * scale,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ],
          ),

          // Ngày sinh/mất nếu bật
          if (config.includeDates) ...[
            pw.SizedBox(height: 1.5 * scale),
            pw.Text(
              member.isAlive
                  ? (member.dateOfBirth != null &&
                          member.dateOfBirth!.isNotEmpty
                      ? 'Sinh: ${member.dateOfBirth}'
                      : 'Còn sống')
                  : 'Mất${member.dateOfDeath != null && member.dateOfDeath!.isNotEmpty ? ": ${member.dateOfDeath}" : ""}',
              style: pw.TextStyle(
                fontSize: 6.5 * scale,
                color: member.isAlive ? colors.textDark : colors.textMuted,
              ),
              maxLines: 1,
            ),
          ],

          // Phối ngẫu nếu bật
          if (config.includeSpouse && spouse != null) ...[
            pw.SizedBox(height: 2 * scale),
            pw.Row(
              children: [
                _buildWeddingRingsIcon(colors.accent, size: 5.5 * scale),
                pw.SizedBox(width: 3 * scale),
                pw.Expanded(
                  child: pw.Text(
                    spouse.fullName,
                    style: pw.TextStyle(
                      fontSize: 6.5 * scale,
                      color: colors.accent,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static pw.Widget _buildWeddingRingsIcon(PdfColor color, {double size = 6}) {
    return pw.SizedBox(
      width: size * 1.6,
      height: size,
      child: pw.Stack(
        children: [
          pw.Positioned(
            left: 0,
            top: 0,
            child: pw.Container(
              width: size,
              height: size,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                border: pw.Border.all(color: color, width: 0.8),
              ),
            ),
          ),
          pw.Positioned(
            right: 0,
            top: 0,
            child: pw.Container(
              width: size,
              height: size,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                border: pw.Border.all(color: color, width: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildBottomBanner(
    FamilyTreePosterConfig config,
    _ThemeColors colors,
    double scale,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          config.compilerName.trim().isNotEmpty
              ? 'Biên soạn: ${config.compilerName.trim()}'
              : 'Gia Tộc Việt - Lưu Hành Nội Bộ',
          style: pw.TextStyle(
            fontSize: 8 * scale,
            color: colors.textMuted,
          ),
        ),
        pw.Text(
          'GIA TỘC TRƯỜNG TỒN - VẠN ĐẠI HƯNG LONG',
          style: pw.TextStyle(
            fontSize: 8.5 * scale,
            fontWeight: pw.FontWeight.bold,
            color: colors.accent,
            letterSpacing: 1 * scale,
          ),
        ),
        pw.Text(
          config.publishYear.trim().isNotEmpty
              ? config.publishYear.trim()
              : 'Khổ in ${config.paperSize.name.toUpperCase()}',
          style: pw.TextStyle(
            fontSize: 8 * scale,
            color: colors.textMuted,
          ),
        ),
      ],
    );
  }

  static PdfPageFormat _getPageFormat(
    PosterPaperSize size,
    PosterOrientation orientation,
  ) {
    PdfPageFormat format;
    switch (size) {
      case PosterPaperSize.a0:
        format = const PdfPageFormat(
          841 * PdfPageFormat.mm,
          1189 * PdfPageFormat.mm,
        );
        break;
      case PosterPaperSize.a1:
        format = const PdfPageFormat(
          594 * PdfPageFormat.mm,
          841 * PdfPageFormat.mm,
        );
        break;
      case PosterPaperSize.a2:
        format = const PdfPageFormat(
          420 * PdfPageFormat.mm,
          594 * PdfPageFormat.mm,
        );
        break;
      case PosterPaperSize.a3:
        format = PdfPageFormat.a3;
        break;
      case PosterPaperSize.a4:
        format = PdfPageFormat.a4;
        break;
    }

    if (orientation == PosterOrientation.landscape) {
      return format.landscape;
    }
    return format;
  }

  static double _getScaleFactor(PosterPaperSize size) {
    switch (size) {
      case PosterPaperSize.a0:
        return 2.8;
      case PosterPaperSize.a1:
        return 2.0;
      case PosterPaperSize.a2:
        return 1.4;
      case PosterPaperSize.a3:
        return 1.0;
      case PosterPaperSize.a4:
        return 0.75;
    }
  }

  static String _toRoman(int number) {
    const romanNumerals = [
      'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
      'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX'
    ];
    if (number >= 1 && number <= romanNumerals.length) {
      return romanNumerals[number - 1];
    }
    return '$number';
  }

  static _ThemeColors _getThemeColors(FamilyBookCoverTheme theme) {
    switch (theme) {
      case FamilyBookCoverTheme.lightTraditional:
        return _ThemeColors(
          primary: PdfColor.fromHex('#7A101C'), // Crimson đỏ đô
          accent: PdfColor.fromHex('#C29236'), // Gold hoàng kim
          backgroundTint: PdfColor.fromHex('#FCF9F2'), // Giấy điệp sáng
          textDark: PdfColor.fromHex('#2B2B2B'),
          textMuted: PdfColor.fromHex('#6E6E6E'),
        );
      case FamilyBookCoverTheme.darkRoyal:
        return _ThemeColors(
          primary: PdfColor.fromHex('#E0C04A'), // Dạ kim sáng
          accent: PdfColor.fromHex('#C62844'), // Đỏ son
          backgroundTint: PdfColor.fromHex('#1E1E1E'), // Nền sơn mài tối
          textDark: PdfColor.fromHex('#F5F5F5'),
          textMuted: PdfColor.fromHex('#B0B0B0'),
        );
      case FamilyBookCoverTheme.plain:
        return _ThemeColors(
          primary: PdfColor.fromHex('#7A101C'), // Crimson đỏ đô
          accent: PdfColor.fromHex('#A07828'), // Bronze hoàng gia
          backgroundTint: PdfColor.fromHex('#FFFFFF'), // Nền trắng trơn
          textDark: PdfColor.fromHex('#222222'),
          textMuted: PdfColor.fromHex('#6E6E6E'),
        );
    }
  }
}

class _ThemeColors {
  const _ThemeColors({
    required this.primary,
    required this.accent,
    required this.backgroundTint,
    required this.textDark,
    required this.textMuted,
  });
  final PdfColor primary;
  final PdfColor accent;
  final PdfColor backgroundTint;
  final PdfColor textDark;
  final PdfColor textMuted;
}
