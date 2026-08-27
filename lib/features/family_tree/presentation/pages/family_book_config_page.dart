import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/models/family_book_config.dart';
import '../../domain/models/family_tree_poster_config.dart';
import 'family_book_preview_page.dart';
import 'family_tree_poster_preview_page.dart';

class FamilyBookConfigPage extends StatefulWidget {
  const FamilyBookConfigPage({
    super.key,
    required this.members,
    this.initialFamilyName,
  });

  final List<MemberEntity> members;
  final String? initialFamilyName;

  @override
  State<FamilyBookConfigPage> createState() => _FamilyBookConfigPageState();
}

class _FamilyBookConfigPageState extends State<FamilyBookConfigPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // ── Phả Ký (Book Config) ──
  late final FamilyBookConfig _config;
  late final TextEditingController _titleController;
  late final TextEditingController _ancestorController;
  late final TextEditingController _addressController;
  late final TextEditingController _compilerController;
  late final TextEditingController _yearController;
  late final TextEditingController _prefaceController;
  late final TextEditingController _rulesController;
  late final TextEditingController _epilogueController;

  // ── Phả Đồ (Poster Config) ──
  late final FamilyTreePosterConfig _posterConfig;
  late final TextEditingController _posterTitleController;
  late final TextEditingController _posterLeftCoupletController;
  late final TextEditingController _posterRightCoupletController;

  int _maxGeneration = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    _config = FamilyBookConfig();
    _posterConfig = FamilyTreePosterConfig();

    // Tìm cụ đời 1 và thế hệ lớn nhất
    MemberEntity? founder;
    for (final m in widget.members) {
      if ((m.generation ?? 1) == 1 && founder == null) {
        founder = m;
      }
      if ((m.generation ?? 1) > _maxGeneration) {
        _maxGeneration = m.generation!;
      }
    }

    String defaultTitle = 'PHẢ KÝ ĐẠI TÔN';
    String defaultPosterTitle = 'PHẢ HỆ ĐỒ ĐẠI TÔN';
    if (widget.initialFamilyName != null &&
        widget.initialFamilyName!.trim().isNotEmpty) {
      final name = widget.initialFamilyName!.trim().toUpperCase();
      defaultTitle =
          name.startsWith('HỌ') ? 'PHẢ KÝ $name' : 'PHẢ KÝ HỌ $name';
      defaultPosterTitle =
          name.startsWith('HỌ') ? 'PHẢ HỆ ĐỒ $name' : 'PHẢ HỆ ĐỒ HỌ $name';
    }

    final founderText = founder != null ? 'Thủy Tổ: ${founder.fullName}' : '';
    final now = DateTime.now();
    final yearText = 'Năm ${now.year} - Lưu hành nội bộ';

    _config.bookTitle = defaultTitle;
    _config.ancestorName = founderText;
    _config.publishYear = yearText;
    _config.endGeneration = _maxGeneration;

    _posterConfig.title = defaultPosterTitle;
    _posterConfig.ancestorName = founderText;
    _posterConfig.publishYear = yearText;
    _posterConfig.endGeneration = _maxGeneration;

    _titleController = TextEditingController(text: defaultTitle);
    _ancestorController = TextEditingController(text: founderText);
    _addressController = TextEditingController(text: _config.originAddress);
    _compilerController = TextEditingController(text: _config.compilerName);
    _yearController = TextEditingController(text: yearText);
    _prefaceController = TextEditingController(text: _config.preface);
    _rulesController = TextEditingController(text: _config.clanRules);
    _epilogueController = TextEditingController(text: _config.epilogue);

    _posterTitleController = TextEditingController(text: defaultPosterTitle);
    _posterLeftCoupletController =
        TextEditingController(text: _posterConfig.leftCouplet);
    _posterRightCoupletController =
        TextEditingController(text: _posterConfig.rightCouplet);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _ancestorController.dispose();
    _addressController.dispose();
    _compilerController.dispose();
    _yearController.dispose();
    _prefaceController.dispose();
    _rulesController.dispose();
    _epilogueController.dispose();

    _posterTitleController.dispose();
    _posterLeftCoupletController.dispose();
    _posterRightCoupletController.dispose();
    super.dispose();
  }

  void _syncConfigValues() {
    // Sync Phả Ký
    _config.bookTitle = _titleController.text.trim();
    _config.ancestorName = _ancestorController.text.trim();
    _config.originAddress = _addressController.text.trim();
    _config.compilerName = _compilerController.text.trim();
    _config.publishYear = _yearController.text.trim();
    _config.preface = _prefaceController.text.trim();
    _config.clanRules = _rulesController.text.trim();
    _config.epilogue = _epilogueController.text.trim();

    // Sync Phả Đồ
    _posterConfig.title = _posterTitleController.text.trim();
    _posterConfig.leftCouplet = _posterLeftCoupletController.text.trim();
    _posterConfig.rightCouplet = _posterRightCoupletController.text.trim();
    _posterConfig.ancestorName = _ancestorController.text.trim();
    _posterConfig.originAddress = _addressController.text.trim();
    _posterConfig.compilerName = _compilerController.text.trim();
    _posterConfig.publishYear = _yearController.text.trim();
  }

  void _goToPreview() {
    _syncConfigValues();
    if (_tabController.index == 0) {
      Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: FamilyBookPreviewPage(
            members: widget.members,
            config: _config,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: FamilyTreePosterPreviewPage(
            members: widget.members,
            config: _posterConfig,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPhaKyTab = _tabController.index == 0;

    return Scaffold(
      appBar: AppAppBar(
        title: 'Xuất Phả Ký & Phả Đồ',
        actions: [
          IconButton(
            tooltip: isPhaKyTab ? 'Xem trước Phả Ký' : 'Xem trước Phả Đồ',
            icon: const Icon(LucideIcons.eye, size: 20),
            onPressed: _goToPreview,
          ),
          const SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.primary,
          indicatorWeight: 2.5,
          labelColor: context.primary,
          unselectedLabelColor: context.textSecondary,
          labelStyle: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(
              icon: Icon(LucideIcons.bookOpen, size: 18),
              text: 'Phả Ký (Sách A4)',
            ),
            Tab(
              icon: Icon(LucideIcons.image, size: 18),
              text: 'Phả Đồ (Tranh)',
            ),
          ],
        ),
      ),
      body: AppBackgroundBody(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPhaKyTab(l10n),
            _buildPhaDoTab(l10n),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // TAB 1: PHẢ KÝ (SÁCH GIA PHẢ A4)
  // ══════════════════════════════════════════════════════

  Widget _buildPhaKyTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── MỤC 1: PHONG CÁCH GIAO DIỆN & BÌA SÁCH ──
          _buildSectionHeader(
            icon: LucideIcons.palette,
            title: l10n.familyBookSectionStyle,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildThemeCard(
                theme: FamilyBookCoverTheme.lightTraditional,
                title: l10n.themeLightLabel,
                imageAsset: 'assets/images/bgcard_light.png',
                currentTheme: _config.coverTheme,
                onSelect: (t) => setState(() => _config.coverTheme = t),
              ),
              const SizedBox(width: 8),
              _buildThemeCard(
                theme: FamilyBookCoverTheme.darkRoyal,
                title: l10n.themeDarkLabel,
                imageAsset: 'assets/images/bgcard_dark.png',
                currentTheme: _config.coverTheme,
                onSelect: (t) => setState(() => _config.coverTheme = t),
              ),
              const SizedBox(width: 8),
              _buildThemeCard(
                theme: FamilyBookCoverTheme.plain,
                title: l10n.themeBlankLabel,
                imageAsset: null,
                currentTheme: _config.coverTheme,
                onSelect: (t) => setState(() => _config.coverTheme = t),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 2: THÔNG TIN ẤN PHẨM & TIỀN NHÂN ──
          _buildSectionHeader(
            icon: LucideIcons.bookMarked,
            title: l10n.familyBookSectionInfo,
          ),
          const SizedBox(height: 12),
          _buildCardWrapper(
            children: [
              AppOutlineTextField(
                controller: _titleController,
                label: l10n.familyBookTitleLabel,
                hintText: l10n.familyBookTitleHint,
                prefixIcon: const Icon(LucideIcons.type, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: _ancestorController,
                label: l10n.familyBookFounderLabel,
                hintText: l10n.familyBookFounderHint,
                prefixIcon: const Icon(LucideIcons.crown, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: _addressController,
                label: l10n.familyBookLocationLabel,
                hintText: l10n.familyBookLocationHint,
                prefixIcon: const Icon(LucideIcons.mapPin, size: 18),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: AppOutlineTextField(
                      controller: _compilerController,
                      label: l10n.familyBookEditorLabel,
                      hintText: l10n.familyBookEditorHint,
                      prefixIcon: const Icon(LucideIcons.userCheck, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppOutlineTextField(
                      controller: _yearController,
                      label: l10n.familyBookYearLabel,
                      hintText: l10n.familyBookYearHint,
                      prefixIcon: const Icon(LucideIcons.calendar, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 3: LỜI TỰA & GIA HUẤN DÒNG TỘC ──
          _buildSectionHeader(
            icon: LucideIcons.feather,
            title: l10n.familyBookSectionPreface,
          ),
          const SizedBox(height: 12),
          _buildCardWrapper(
            padding: EdgeInsets.zero,
            children: [
              _buildExpandableEditor(
                icon: LucideIcons.bookOpen,
                title: l10n.familyBookPrefaceTab,
                controller: _prefaceController,
                defaultText: FamilyBookConfig.defaultPreface,
                isInitiallyExpanded: true,
              ),
              _buildDivider(),
              _buildExpandableEditor(
                icon: LucideIcons.shieldCheck,
                title: l10n.familyBookRulesTab,
                controller: _rulesController,
                defaultText: FamilyBookConfig.defaultClanRules,
              ),
              _buildDivider(),
              _buildExpandableEditor(
                icon: LucideIcons.heartHandshake,
                title: l10n.familyBookMemorialTab,
                controller: _epilogueController,
                defaultText: FamilyBookConfig.defaultEpilogue,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 4: TÙY CHỌN NỘI DUNG XUẤT BẢN ──
          _buildSectionHeader(
            icon: LucideIcons.slidersHorizontal,
            title: l10n.familyBookSectionContent,
          ),
          const SizedBox(height: 12),
          _buildCardWrapper(
            children: [
              // Thanh chọn phạm vi thế hệ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phạm vi thế hệ xuất bản',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Đời ${_config.startGeneration} - Đời ${_config.endGeneration ?? _maxGeneration}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RangeSlider(
                values: RangeValues(
                  _config.startGeneration.toDouble(),
                  (_config.endGeneration ?? _maxGeneration).toDouble(),
                ),
                min: 1,
                max: _maxGeneration > 1 ? _maxGeneration.toDouble() : 2,
                divisions: _maxGeneration > 1 ? _maxGeneration - 1 : 1,
                activeColor: context.primary,
                inactiveColor: context.accent.withValues(alpha: 0.25),
                onChanged: (values) {
                  setState(() {
                    _config.startGeneration = values.start.round();
                    _config.endGeneration = values.end.round();
                  });
                },
              ),
              _buildDivider(),

              // 1. Cây gia phả
              _buildSwitchTile(
                title: l10n.familyBookOptTreeChart,
                subtitle: l10n.familyBookOptTreeChartDesc,
                value: _config.includeTreeChart,
                onChanged: (v) => setState(() => _config.includeTreeChart = v),
              ),
              _buildDivider(),

              // 2. Thống kê
              _buildSwitchTile(
                title: l10n.familyBookOptStats,
                subtitle: l10n.familyBookOptStatsDesc,
                value: _config.includeStatistics,
                onChanged: (v) => setState(() => _config.includeStatistics = v),
              ),
              _buildDivider(),

              // 3. Lịch giỗ
              _buildSwitchTile(
                title: l10n.familyBookOptAnniversary,
                subtitle: l10n.familyBookOptAnniversaryDesc,
                value: _config.includeMemorialCalendar,
                onChanged: (v) =>
                    setState(() => _config.includeMemorialCalendar = v),
              ),
              _buildDivider(),

              // 4. Mộ phần
              _buildSwitchTile(
                title: l10n.familyBookOptTombs,
                subtitle: l10n.familyBookOptTombsDesc,
                value: _config.includeBurialInfo,
                onChanged: (v) => setState(() => _config.includeBurialInfo = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // TAB 2: PHẢ ĐỒ (TRANH TREO TƯỜNG KHỔ LỚN)
  // ══════════════════════════════════════════════════════

  Widget _buildPhaDoTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── MỤC 1: KHỔ IN & CHIỀU TRANH ──
          _buildSectionHeader(
            icon: LucideIcons.scaling,
            title: '1. Khổ In & Hướng Tranh',
          ),
          const SizedBox(height: 12),
          _buildCardWrapper(
            children: [
              Text(
                'Kích thước khổ giấy',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Hàng 5 nút khổ giấy vừa vặn màn hình
              Row(
                children: [
                  _buildPaperSizeSegment(PosterPaperSize.a0, 'A0'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(PosterPaperSize.a1, 'A1'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(PosterPaperSize.a2, 'A2'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(PosterPaperSize.a3, 'A3'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(PosterPaperSize.a4, 'A4'),
                ],
              ),
              const SizedBox(height: 8),
              // Dòng mô tả chi tiết kích thước
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 14,
                      color: context.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getPaperSizeDescription(_posterConfig.paperSize),
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11.5,
                          color: context.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildDivider(),
              Text(
                'Hướng bố cục tranh',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildOrientationSegment(
                      orientation: PosterOrientation.landscape,
                      title: 'Khổ Ngang',
                      icon: LucideIcons.layoutGrid,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildOrientationSegment(
                      orientation: PosterOrientation.portrait,
                      title: 'Khổ Dọc',
                      icon: LucideIcons.fileText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 2: PHONG CÁCH NỀN & KHUNG TRANH ──
          _buildSectionHeader(
            icon: LucideIcons.palette,
            title: '2. Phong Cách Nền & Khung Tranh',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildThemeCard(
                theme: FamilyBookCoverTheme.lightTraditional,
                title: l10n.themeLightLabel,
                imageAsset: 'assets/images/bgcard_light.png',
                currentTheme: _posterConfig.posterTheme,
                onSelect: (t) => setState(() => _posterConfig.posterTheme = t),
              ),
              const SizedBox(width: 8),
              _buildThemeCard(
                theme: FamilyBookCoverTheme.darkRoyal,
                title: l10n.themeDarkLabel,
                imageAsset: 'assets/images/bgcard_dark.png',
                currentTheme: _posterConfig.posterTheme,
                onSelect: (t) => setState(() => _posterConfig.posterTheme = t),
              ),
              const SizedBox(width: 8),
              _buildThemeCard(
                theme: FamilyBookCoverTheme.plain,
                title: l10n.themeBlankLabel,
                imageAsset: null,
                currentTheme: _posterConfig.posterTheme,
                onSelect: (t) => setState(() => _posterConfig.posterTheme = t),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 3: TIÊU ĐỀ & CÂU ĐỐI NHÀ THỜ HỌ ──
          _buildSectionHeader(
            icon: LucideIcons.scroll,
            title: '3. Tiêu Đề & Câu Đối Nhà Thờ Họ',
          ),
          const SizedBox(height: 12),
          _buildCardWrapper(
            children: [
              AppOutlineTextField(
                controller: _posterTitleController,
                label: 'Tiêu đề Tranh Phả Đồ',
                hintText: 'VD: PHẢ HỆ ĐỒ ĐẠI TÔN HỌ NGUYỄN',
                prefixIcon: const Icon(LucideIcons.type, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: _posterLeftCoupletController,
                label: 'Câu đối vế trái (Thượng liên)',
                hintText: 'VD: Tổ tông công đức thiên niên thịnh',
                prefixIcon: const Icon(LucideIcons.alignLeft, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: _posterRightCoupletController,
                label: 'Câu đối vế phải (Hạ liên)',
                hintText: 'VD: Tử hiếu tôn hiền vạn đại vinh',
                prefixIcon: const Icon(LucideIcons.alignRight, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 4: PHẠM VI & TÙY CHỌN HIỂN THỊ ──
          _buildSectionHeader(
            icon: LucideIcons.slidersHorizontal,
            title: '4. Phạm Vi & Tùy Chọn Hiển Thị',
          ),
          const SizedBox(height: 12),
          _buildCardWrapper(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phạm vi thế hệ trên tranh',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Đời ${_posterConfig.startGeneration} - Đời ${_posterConfig.endGeneration ?? _maxGeneration}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RangeSlider(
                values: RangeValues(
                  _posterConfig.startGeneration.toDouble(),
                  (_posterConfig.endGeneration ?? _maxGeneration).toDouble(),
                ),
                min: 1,
                max: _maxGeneration > 1 ? _maxGeneration.toDouble() : 2,
                divisions: _maxGeneration > 1 ? _maxGeneration - 1 : 1,
                activeColor: context.primary,
                inactiveColor: context.accent.withValues(alpha: 0.25),
                onChanged: (values) {
                  setState(() {
                    _posterConfig.startGeneration = values.start.round();
                    _posterConfig.endGeneration = values.end.round();
                  });
                },
              ),
              _buildDivider(),

              // Hiển thị phối ngẫu
              _buildSwitchTile(
                title: 'Hiển thị Phối ngẫu (Vợ / Chồng)',
                subtitle: 'Kèm tên phu nhân hoặc phu quân trong từng thẻ',
                value: _posterConfig.includeSpouse,
                onChanged: (v) =>
                    setState(() => _posterConfig.includeSpouse = v),
              ),
              _buildDivider(),

              // Hiển thị năm sinh / mất
              _buildSwitchTile(
                title: 'Hiển thị Năm Sinh & Năm Mất',
                subtitle: 'Ghi chú niên đại sinh tử của các bậc tiền nhân',
                value: _posterConfig.includeDates,
                onChanged: (v) =>
                    setState(() => _posterConfig.includeDates = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ══════════════════════════════════════════════════════

  Widget _buildPaperSizeSegment(PosterPaperSize size, String label) {
    final isSelected = _posterConfig.paperSize == size;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _posterConfig.paperSize = size),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? context.primary : context.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? context.primary
                  : context.accent.withValues(alpha: 0.22),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.primary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? Colors.white : context.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  String _getPaperSizeDescription(PosterPaperSize size) {
    switch (size) {
      case PosterPaperSize.a0:
        return 'Khổ A0 (84.1 × 118.9 cm) • Khổ đại cho Từ Đường, Nhà Thờ Họ';
      case PosterPaperSize.a1:
        return 'Khổ A1 (59.4 × 84.1 cm) • Kích thước chuẩn treo tường đẹp nhất';
      case PosterPaperSize.a2:
        return 'Khổ A2 (42.0 × 59.4 cm) • Phù hợp không gian phòng khách vừa';
      case PosterPaperSize.a3:
        return 'Khổ A3 (29.7 × 42.0 cm) • Khổ nhỏ đóng khung để bàn / treo tường';
      case PosterPaperSize.a4:
        return 'Khổ A4 (21.0 × 29.7 cm) • Tiêu chuẩn in ấn kẹp hồ sơ gia phả';
    }
  }

  Widget _buildOrientationSegment({
    required PosterOrientation orientation,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _posterConfig.orientation == orientation;

    return GestureDetector(
      onTap: () => setState(() => _posterConfig.orientation = orientation),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primary.withValues(alpha: 0.1)
              : context.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? context.primary
                : context.accent.withValues(alpha: 0.22),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? context.primary : context.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? context.primary : context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard({
    required FamilyBookCoverTheme theme,
    required String title,
    required String? imageAsset,
    required FamilyBookCoverTheme currentTheme,
    required ValueChanged<FamilyBookCoverTheme> onSelect,
  }) {
    final isSelected = currentTheme == theme;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(theme),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? context.primary
                  : context.accent.withValues(alpha: 0.18),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.primary.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 1.45,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageAsset != null)
                        Image.asset(
                          imageAsset,
                          fit: BoxFit.fill,
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: context.background,
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.2),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.fileText,
                                  size: 20,
                                  color: context.textSecondary,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Nền trơn',
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                    color: context.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isSelected)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? context.primary : context.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: context.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardWrapper({
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        thickness: 0.6,
        color: context.accent.withValues(alpha: 0.15),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11.5,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: value,
          activeTrackColor: context.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildExpandableEditor({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required String defaultText,
    bool isInitiallyExpanded = false,
  }) {
    final l10n = AppLocalizations.of(context);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: isInitiallyExpanded,
        leading: Icon(icon, size: 18, color: context.primary),
        title: Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        children: [
          AppOutlineTextField(
            controller: controller,
            label: 'Nội dung',
            hintText: 'Nhập nội dung...',
            maxLines: 6,
            minLines: 3,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                controller.text = defaultText;
              },
              icon: const Icon(LucideIcons.rotateCcw, size: 14),
              label: Text(l10n.familyBookResetDefault),
              style: TextButton.styleFrom(
                foregroundColor: context.textSecondary,
                textStyle: GoogleFonts.beVietnamPro(fontSize: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
