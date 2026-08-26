import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:vnlunar/vnlunar.dart';

import '../entities/member_entity.dart';
import '../models/family_book_config.dart';

class FamilyBookPdfService {
  Future<Uint8List> generateBookPdf({
    required List<MemberEntity> members,
    required FamilyBookConfig config,
  }) async {
    final pdf = pw.Document();

    // 1. Tải font Google Fonts hỗ trợ 100% tiếng Việt Unicode
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

    // 2. Thiết lập bảng màu theo Theme được chọn
    final colors = _getThemeColors(config.coverTheme);

    // 2.1 Tải hình nền hoa văn theo chủ đề (Sáng / Tối / Để trống)
    final String? bgAssetPath =
        config.coverTheme == FamilyBookCoverTheme.darkRoyal
            ? 'assets/images/bgcard_dark.png'
            : config.coverTheme == FamilyBookCoverTheme.lightTraditional
                ? 'assets/images/bgcard_light.png'
                : null;

    Uint8List? bgImageBytes;
    if (bgAssetPath != null) {
      try {
        final byteData = await rootBundle.load(bgAssetPath);
        bgImageBytes = byteData.buffer.asUint8List();
      } catch (_) {}
    }

    // 3. Phân loại và xử lý dữ liệu gia phả
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

    // ── TRANG 1: TRANG BÌA CHÍNH (COVER PAGE) ──
    if (config.includeCover) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: themeData,
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.Stack(
              fit: pw.StackFit.expand,
              children: [
                if (bgImageBytes != null)
                  pw.Image(
                    pw.MemoryImage(bgImageBytes),
                    fit: pw.BoxFit.cover,
                  )
                else
                  pw.Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: colors.backgroundTint,
                  ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 52, vertical: 64),
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      // Tiêu đề đầu
                      pw.Column(
                        children: [
                          pw.Text(
                            'CỘI NGUỒN DÒNG TỘC',
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: colors.accent,
                              letterSpacing: 3,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Container(
                            width: 80,
                            height: 1.5,
                            color: colors.accent,
                          ),
                        ],
                      ),

                      // Đại tự Tên Sách
                      pw.Column(
                        children: [
                          pw.Text(
                            config.bookTitle.toUpperCase(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 26,
                              fontWeight: pw.FontWeight.bold,
                              color: colors.primary,
                              letterSpacing: 2,
                              lineSpacing: 4,
                            ),
                          ),
                          if (config.ancestorName.trim().isNotEmpty) ...[
                            pw.SizedBox(height: 16),
                            pw.Text(
                              config.ancestorName.trim(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: colors.textDark,
                              ),
                            ),
                          ],
                          if (config.originAddress.trim().isNotEmpty) ...[
                            pw.SizedBox(height: 8),
                            pw.Text(
                              config.originAddress.trim(),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontStyle: pw.FontStyle.italic,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Chân bìa: Người biên soạn & Niên hiệu
                      pw.Column(
                        children: [
                          pw.Container(
                            width: 60,
                            height: 1,
                            color: colors.accent,
                          ),
                          pw.SizedBox(height: 10),
                          if (config.compilerName.trim().isNotEmpty)
                            pw.Text(
                              config.compilerName.trim(),
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            config.publishYear.trim().isNotEmpty
                                ? config.publishYear.trim()
                                : 'LƯU HÀNH NỘI BỘ GIA TỘC',
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              fontStyle: pw.FontStyle.italic,
                              color: colors.textMuted,
                            ),
                          ),
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
    }

    // ── TRANG 2: LỜI TỰA & TỘC ƯỚC (PREFACE & CLAN RULES) ──
    if (config.includePreface || config.includeClanRules) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: themeData,
          margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 40),
          header: (context) => _buildPageHeader(config.bookTitle, colors),
          footer: (context) => _buildPageFooter(context, colors),
          build: (context) {
            return [
              if (config.includePreface) ...[
                _buildSectionHeader('LỜI NÓI ĐẦU', colors),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: colors.backgroundTint,
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(6)),
                    border: pw.Border.all(color: colors.accent, width: 0.6),
                  ),
                  child: pw.Text(
                    config.preface,
                    style: pw.TextStyle(
                      fontSize: 10.5,
                      lineSpacing: 5,
                      color: colors.textDark,
                    ),
                    textAlign: pw.TextAlign.justify,
                  ),
                ),
                pw.SizedBox(height: 24),
              ],
              if (config.includeClanRules) ...[
                _buildSectionHeader('TỘC ƯỚC & GIA HUẤN', colors),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: colors.backgroundTint,
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(6)),
                    border: pw.Border.all(color: colors.accent, width: 0.6),
                  ),
                  child: pw.Text(
                    config.clanRules,
                    style: pw.TextStyle(
                      fontSize: 10.5,
                      lineSpacing: 5,
                      color: colors.textDark,
                    ),
                    textAlign: pw.TextAlign.justify,
                  ),
                ),
              ],
            ];
          },
        ),
      );
    }

    // ── TRANG 3: THỐNG KÊ NHÂN KHẨU DÒNG HỌ ──
    if (config.includeStatistics) {
      final totalMembers = members.length;
      final aliveMembers = members.where((m) => m.isAlive).length;
      final deceasedMembers = totalMembers - aliveMembers;
      final maleMembers = members.where((m) => m.gender == Gender.male).length;
      final femaleMembers =
          members.where((m) => m.gender == Gender.female).length;
      final totalGens = sortedGenerations.length;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: themeData,
          margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 40),
          header: (context) => _buildPageHeader(config.bookTitle, colors),
          footer: (context) => _buildPageFooter(context, colors),
          build: (context) {
            return [
              _buildSectionHeader('TỔNG QUAN & THỐNG KÊ DÒNG HỌ', colors),
              pw.SizedBox(height: 16),
              pw.Table(
                border: pw.TableBorder.all(color: colors.accent, width: 0.6),
                children: [
                  _buildTableRow(
                    'Tổng số thế hệ ghi nhận',
                    '$totalGens đời',
                    colors,
                  ),
                  _buildTableRow(
                    'Tổng số nhân đinh & dâu rể',
                    '$totalMembers người',
                    colors,
                  ),
                  _buildTableRow(
                    'Số thành viên Nam',
                    '$maleMembers người',
                    colors,
                  ),
                  _buildTableRow(
                    'Số thành viên Nữ & Dâu',
                    '$femaleMembers người',
                    colors,
                  ),
                  _buildTableRow(
                    'Thành viên hiện còn sống',
                    '$aliveMembers người',
                    colors,
                  ),
                  _buildTableRow(
                    'Tiền nhân đã quy tiên',
                    '$deceasedMembers vị',
                    colors,
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
            ];
          },
        ),
      );
    }

    // ── TRANG: SƠ ĐỒ CÂY GIA PHẢ TRỰC QUAN (FAMILY TREE CHART) ──
    if (config.includeTreeChart && sortedGenerations.isNotEmpty) {
      final memberMap = {for (final m in members) m.id: m};

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: themeData,
          margin: const pw.EdgeInsets.fromLTRB(36, 36, 36, 36),
          header: (context) => _buildPageHeader(config.bookTitle, colors),
          footer: (context) => _buildPageFooter(context, colors),
          build: (context) {
            final treeWidgets = <pw.Widget>[
              _buildSectionHeader(
                  'SƠ ĐỒ CÂY GIA PHẢ - TRỰC HỆ TÔNG CHI', colors),
              pw.SizedBox(height: 8),
              pw.Text(
                'Sơ đồ phân nhánh phả hệ theo từng thế hệ truyền thừa từ đời Tiên Tổ',
                style: pw.TextStyle(
                  fontSize: 9.5,
                  fontStyle: pw.FontStyle.italic,
                  color: colors.textMuted,
                ),
              ),
              pw.SizedBox(height: 16),
            ];

            for (int i = 0; i < sortedGenerations.length; i++) {
              final gen = sortedGenerations[i];
              final genMembers = generationMap[gen] ?? [];
              final romanGen = _toRoman(gen);

              treeWidgets.add(
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Badge thế hệ
                      pw.Row(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: pw.BoxDecoration(
                              color: colors.primary,
                              borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(4)),
                            ),
                            child: pw.Text(
                              'ĐỜI $romanGen',
                              style: pw.TextStyle(
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Text(
                            gen == 1
                                ? 'Thủy Tổ / Khởi Tổ Phát Tích'
                                : 'Thế Hệ Đời Thứ $gen (${genMembers.length} thành viên)',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),

                      // Danh sách các node thành viên trong đời
                      pw.Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: genMembers.map((m) {
                          final parent = m.parentId != null
                              ? memberMap[m.parentId!]
                              : null;
                          final spouse = m.spouseId != null
                              ? memberMap[m.spouseId!]
                              : null;

                          return _buildTreeNodeCard(
                            m,
                            parent: parent,
                            spouse: spouse,
                            colors: colors,
                          );
                        }).toList(),
                      ),
                      if (i < sortedGenerations.length - 1) ...[
                        pw.SizedBox(height: 10),
                        pw.Center(
                          child: pw.Container(
                            width: 1.5,
                            height: 14,
                            color: colors.accent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }

            return treeWidgets;
          },
        ),
      );
    }

    // ── TRANG 4: PHẢ HỆ CHI TIẾT TỪNG ĐỜI ──
    if (config.includeGenerations && sortedGenerations.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: themeData,
          margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 40),
          header: (context) => _buildPageHeader(config.bookTitle, colors),
          footer: (context) => _buildPageFooter(context, colors),
          build: (context) {
            final content = <pw.Widget>[];

            for (final gen in sortedGenerations) {
              final genMembers = generationMap[gen] ?? [];
              final romanGen = _toRoman(gen);

              content.add(
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 14, bottom: 10),
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: colors.primary,
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'ĐỜI THỨ $romanGen (THẾ HỆ $gen)',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      pw.Text(
                        '${genMembers.length} thành viên',
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontStyle: pw.FontStyle.italic,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );

              for (int i = 0; i < genMembers.length; i++) {
                final m = genMembers[i];
                final children = sortedMembers
                    .where((child) =>
                        child.parentId == m.id || child.motherId == m.id)
                    .toList();

                MemberEntity? spouse;
                if (m.spouseId != null) {
                  spouse = sortedMembers
                      .where((s) => s.id == m.spouseId)
                      .firstOrNull;
                }

                content.add(
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: i.isEven ? colors.backgroundTint : PdfColors.white,
                      border: pw.Border.all(color: colors.accent, width: 0.5),
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Tên và thông tin cơ bản
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text(
                                  '${i + 1}. ${m.fullName.toUpperCase()}',
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    fontWeight: pw.FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Text(
                                  m.gender == Gender.female ? '(Nữ)' : '(Nam)',
                                  style: pw.TextStyle(
                                    fontSize: 9.5,
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1.5),
                              decoration: pw.BoxDecoration(
                                color: m.isAlive
                                    ? PdfColor.fromHex('#E8F5E9')
                                    : PdfColor.fromHex('#F5F5F5'),
                                borderRadius: const pw.BorderRadius.all(
                                    pw.Radius.circular(3)),
                              ),
                              child: pw.Text(
                                m.isAlive ? 'Còn sống' : 'Đã mất',
                                style: pw.TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: m.isAlive
                                      ? PdfColor.fromHex('#2E7D32')
                                      : colors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 4),

                        // Năm sinh / Năm mất
                        pw.Row(
                          children: [
                            if (m.dateOfBirth != null &&
                                m.dateOfBirth!.isNotEmpty)
                              pw.Text(
                                'Sinh: ${m.dateOfBirth}   ',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  color: colors.textDark,
                                ),
                              ),
                            if (!m.isAlive) ...[
                              if (m.lunarDeathDate != null &&
                                  m.lunarDeathDate!.isNotEmpty)
                                pw.Text(
                                  'Giỗ ÂL: ${m.lunarDeathDate}   ',
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: colors.primary,
                                  ),
                                ),
                              if (m.dateOfDeath != null &&
                                  m.dateOfDeath!.isNotEmpty)
                                pw.Text(
                                  'Mất: ${m.dateOfDeath}',
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: colors.textDark,
                                  ),
                                ),
                            ],
                          ],
                        ),

                        // Vợ / Chồng
                        if (spouse != null) ...[
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Phối ngẫu: ${spouse.fullName} ${spouse.isAlive ? "" : "(Đã mất)"}',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontStyle: pw.FontStyle.italic,
                              color: colors.textDark,
                            ),
                          ),
                        ],

                        // Danh sách con cái
                        if (children.isNotEmpty) ...[
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Con cái (${children.length}): ${children.map((c) => c.fullName).join(", ")}',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: colors.textDark,
                            ),
                          ),
                        ],

                        // Ghi chú / Mộ phần
                        if (config.includeBurialInfo &&
                            m.notes != null &&
                            m.notes!.trim().isNotEmpty) ...[
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Ghi chú / Mộ phần: ${m.notes!.trim()}',
                            style: pw.TextStyle(
                              fontSize: 9,
                              color: colors.accent,
                              fontStyle: pw.FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
            }

            return content;
          },
        ),
      );
    }

    // ── TRANG 5: BẢNG TRA CỨU NGÀY GIỖ TRONG NĂM ──
    if (config.includeMemorialCalendar) {
      final deceasedList = members.where((m) => !m.isAlive).toList();

      // Trích xuất và sắp xếp theo ngày tháng âm lịch
      final parsedList = <_MemorialItem>[];
      for (final m in deceasedList) {
        int? lDay;
        int? lMonth;
        if (m.lunarDeathDate != null && m.lunarDeathDate!.isNotEmpty) {
          final match = RegExp(r'(\d+)\/(\d+)').firstMatch(m.lunarDeathDate!);
          if (match != null) {
            lDay = int.tryParse(match.group(1) ?? '');
            lMonth = int.tryParse(match.group(2) ?? '');
          }
        }
        if (lDay == null || lMonth == null) {
          if (m.dateOfDeath != null && m.dateOfDeath!.isNotEmpty) {
            try {
              final p = m.dateOfDeath!.split('-');
              if (p.length == 3) {
                final y = int.parse(p[0]);
                final mo = int.parse(p[1]);
                final d = int.parse(p[2]);
                final l =
                    Lunar(createdFromSolar: true, date: DateTime(y, mo, d));
                lDay = l.day;
                lMonth = l.month;
              }
            } catch (_) {}
          }
        }
        if (lDay != null && lMonth != null) {
          parsedList.add(_MemorialItem(
            member: m,
            lunarDay: lDay,
            lunarMonth: lMonth,
          ));
        }
      }

      parsedList.sort((a, b) {
        if (a.lunarMonth != b.lunarMonth) {
          return a.lunarMonth.compareTo(b.lunarMonth);
        }
        return a.lunarDay.compareTo(b.lunarDay);
      });

      if (parsedList.isNotEmpty) {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            theme: themeData,
            margin: const pw.EdgeInsets.fromLTRB(40, 40, 40, 40),
            header: (context) => _buildPageHeader(config.bookTitle, colors),
            footer: (context) => _buildPageFooter(context, colors),
            build: (context) {
              return [
                _buildSectionHeader(
                    'BẢNG TRA CỨU NGÀY GIỖ TIỀN NHÂN (ÂM LỊCH)', colors),
                pw.SizedBox(height: 12),
                pw.Table(
                  border: pw.TableBorder.all(color: colors.accent, width: 0.5),
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1.2),
                    1: pw.FlexColumnWidth(2.5),
                    2: pw.FlexColumnWidth(),
                    3: pw.FlexColumnWidth(2.5),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: colors.primary),
                      children: [
                        _buildTableHeaderCell('Ngày Giỗ ÂL', PdfColors.white),
                        _buildTableHeaderCell(
                            'Danh Tính Tiền Nhân', PdfColors.white),
                        _buildTableHeaderCell('Thế Hệ', PdfColors.white),
                        _buildTableHeaderCell(
                            'Ghi Chú / Nơi An Táng', PdfColors.white),
                      ],
                    ),
                    for (int i = 0; i < parsedList.length; i++)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: i.isEven
                              ? colors.backgroundTint
                              : PdfColors.white,
                        ),
                        children: [
                          _buildTableCell(
                            '${parsedList[i].lunarDay.toString().padLeft(2, "0")}/${parsedList[i].lunarMonth.toString().padLeft(2, "0")} ÂL',
                            isBold: true,
                            color: colors.primary,
                          ),
                          _buildTableCell(
                            parsedList[i].member.fullName,
                            isBold: true,
                            color: colors.textDark,
                          ),
                          _buildTableCell(
                            'Đời ${parsedList[i].member.generation ?? 1}',
                            color: colors.textMuted,
                          ),
                          _buildTableCell(
                            parsedList[i].member.notes ?? 'Chưa cập nhật',
                            color: colors.textDark,
                          ),
                        ],
                      ),
                  ],
                ),
              ];
            },
          ),
        );
      }
    }

    // ── TRANG 6: LỜI BẠT & BÌA SAU (EPILOGUE) ──
    if (config.includeEpilogue && config.epilogue.trim().isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: themeData,
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.Stack(
              fit: pw.StackFit.expand,
              children: [
                if (bgImageBytes != null)
                  pw.Image(
                    pw.MemoryImage(bgImageBytes),
                    fit: pw.BoxFit.cover,
                  )
                else
                  pw.Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: colors.backgroundTint,
                  ),
                pw.Center(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 52),
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'LỜI BẠT',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: colors.primary,
                            letterSpacing: 2,
                          ),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Container(
                          width: 50,
                          height: 1.2,
                          color: colors.accent,
                        ),
                        pw.SizedBox(height: 20),
                        pw.Padding(
                          padding:
                              const pw.EdgeInsets.symmetric(horizontal: 20),
                          child: pw.Text(
                            config.epilogue,
                            textAlign: pw.TextAlign.justify,
                            style: pw.TextStyle(
                              fontSize: 11.5,
                              fontStyle: pw.FontStyle.italic,
                              lineSpacing: 6,
                              color: colors.textDark,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 30),
                        pw.Text(
                          'GIA TỘC TRƯỜNG TỒN - VẠN ĐẠI HƯNG LONG',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: colors.accent,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  // ── Helper Widgets ──

  static pw.Widget _buildPageHeader(String title, _ThemeColors colors) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: pw.BoxDecoration(
        border:
            pw.Border(bottom: pw.BorderSide(color: colors.accent, width: 0.6)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: colors.primary,
            ),
          ),
          pw.Text(
            'TỘC PHẢ ĐẠI TÔN',
            style: pw.TextStyle(
              fontSize: 8.5,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPageFooter(pw.Context context, _ThemeColors colors) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 12),
      padding: const pw.EdgeInsets.only(top: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: colors.accent, width: 0.6)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Gia Tộc Việt - Lưu Hành Nội Bộ',
            style: pw.TextStyle(fontSize: 8, color: colors.textMuted),
          ),
          pw.Text(
            'Trang ${context.pageNumber} / ${context.pagesCount}',
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: colors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionHeader(String title, _ThemeColors colors) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: colors.primary,
            letterSpacing: 1,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          width: 50,
          height: 1.5,
          color: colors.accent,
        ),
      ],
    );
  }

  static pw.TableRow _buildTableRow(
    String title,
    String value,
    _ThemeColors colors, {
    bool isHeader = false,
  }) {
    return pw.TableRow(
      decoration: isHeader
          ? pw.BoxDecoration(color: colors.primary)
          : pw.BoxDecoration(color: colors.backgroundTint),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isHeader ? PdfColors.white : colors.textDark,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: isHeader ? PdfColors.white : colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeaderCell(String text, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  static pw.Widget _buildTableCell(
    String text, {
    bool isBold = false,
    required PdfColor color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  static String _toRoman(int number) {
    const romanNumerals = [
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII',
      'XIII',
      'XIV',
      'XV',
      'XVI',
      'XVII',
      'XVIII',
      'XIX',
      'XX'
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

  static pw.Widget _buildTreeNodeCard(
    MemberEntity member, {
    MemberEntity? parent,
    MemberEntity? spouse,
    required _ThemeColors colors,
  }) {
    final isMale = member.gender == Gender.male;
    final nodeBorderColor = isMale ? colors.primary : colors.accent;

    return pw.Container(
      width: 155,
      padding: const pw.EdgeInsets.all(7),
      decoration: pw.BoxDecoration(
        color: colors.backgroundTint,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
        border: pw.Border.all(color: nodeBorderColor, width: 1.2),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          // Tên thành viên
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  member.fullName.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 9.5,
                    fontWeight: pw.FontWeight.bold,
                    color: colors.primary,
                  ),
                  maxLines: 1,
                ),
              ),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: pw.BoxDecoration(
                  color: isMale ? colors.primary : colors.accent,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(2)),
                ),
                child: pw.Text(
                  isMale ? 'Nam' : 'Nữ',
                  style: pw.TextStyle(
                    fontSize: 6.5,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 3),

          // Sinh - Mất
          pw.Text(
            member.isAlive
                ? (member.dateOfBirth != null
                    ? 'Sinh: ${member.dateOfBirth}'
                    : 'Hiện còn sống')
                : 'Đã tạ thế${member.dateOfDeath != null ? ' (${member.dateOfDeath})' : ''}',
            style: pw.TextStyle(
              fontSize: 7.5,
              color: member.isAlive ? colors.textDark : colors.textMuted,
            ),
          ),

          // Cha mẹ (nếu có)
          if (parent != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              '└ Con cụ: ${parent.fullName}',
              style: pw.TextStyle(
                fontSize: 7.5,
                color: colors.textMuted,
                fontStyle: pw.FontStyle.italic,
              ),
              maxLines: 1,
            ),
          ],

          // Phối ngẫu (nếu có)
          if (spouse != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              '⚭ Phối: ${spouse.fullName}',
              style: pw.TextStyle(
                fontSize: 7.5,
                color: colors.accent,
                fontWeight: pw.FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ],
        ],
      ),
    );
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

class _MemorialItem {
  const _MemorialItem({
    required this.member,
    required this.lunarDay,
    required this.lunarMonth,
  });
  final MemberEntity member;
  final int lunarDay;
  final int lunarMonth;
}
