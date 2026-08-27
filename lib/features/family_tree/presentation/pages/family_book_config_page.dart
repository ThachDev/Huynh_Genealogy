import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/member_entity.dart';
import '../../domain/models/family_book_config.dart';
import 'family_book_preview_page.dart';

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

class _FamilyBookConfigPageState extends State<FamilyBookConfigPage> {
  late final FamilyBookConfig _config;

  late final TextEditingController _titleController;
  late final TextEditingController _ancestorController;
  late final TextEditingController _addressController;
  late final TextEditingController _compilerController;
  late final TextEditingController _yearController;
  late final TextEditingController _prefaceController;
  late final TextEditingController _rulesController;
  late final TextEditingController _epilogueController;

  int _maxGeneration = 1;

  @override
  void initState() {
    super.initState();
    _config = FamilyBookConfig();

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

    String defaultTitle = 'GIA PHẢ ĐẠI TÔN';
    if (widget.initialFamilyName != null &&
        widget.initialFamilyName!.trim().isNotEmpty) {
      final name = widget.initialFamilyName!.trim().toUpperCase();
      defaultTitle =
          name.startsWith('HỌ') ? 'GIA PHẢ $name' : 'GIA PHẢ HỌ $name';
    }

    final founderText = founder != null ? 'Thủy Tổ: ${founder.fullName}' : '';
    final now = DateTime.now();
    final yearText = 'Năm ${now.year} - Lưu hành nội bộ';

    _config.bookTitle = defaultTitle;
    _config.ancestorName = founderText;
    _config.publishYear = yearText;
    _config.endGeneration = _maxGeneration;

    _titleController = TextEditingController(text: defaultTitle);
    _ancestorController = TextEditingController(text: founderText);
    _addressController = TextEditingController(text: _config.originAddress);
    _compilerController = TextEditingController(text: _config.compilerName);
    _yearController = TextEditingController(text: yearText);
    _prefaceController = TextEditingController(text: _config.preface);
    _rulesController = TextEditingController(text: _config.clanRules);
    _epilogueController = TextEditingController(text: _config.epilogue);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ancestorController.dispose();
    _addressController.dispose();
    _compilerController.dispose();
    _yearController.dispose();
    _prefaceController.dispose();
    _rulesController.dispose();
    _epilogueController.dispose();
    super.dispose();
  }

  void _syncConfigValues() {
    _config.bookTitle = _titleController.text.trim();
    _config.ancestorName = _ancestorController.text.trim();
    _config.originAddress = _addressController.text.trim();
    _config.compilerName = _compilerController.text.trim();
    _config.publishYear = _yearController.text.trim();
    _config.preface = _prefaceController.text.trim();
    _config.clanRules = _rulesController.text.trim();
    _config.epilogue = _epilogueController.text.trim();
  }

  void _goToPreview() {
    _syncConfigValues();
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: FamilyBookPreviewPage(
          members: widget.members,
          config: _config,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppAppBar(
        title: l10n.familyBookConfigTitle,
        actions: [
          IconButton(
            tooltip: l10n.familyBookPreviewPdf,
            icon: const Icon(LucideIcons.eye, size: 20),
            onPressed: _goToPreview,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AppBackgroundBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── PHẦN 1: CHỌN PHONG CÁCH BÌA ──
              AppSectionHeader(
                title: l10n.familyBookSectionStyle,
                titleSize: 15,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildThemeCard(
                    theme: FamilyBookCoverTheme.lightTraditional,
                    title: l10n.themeLightLabel,
                    imageAsset: 'assets/images/bgcard_light.png',
                  ),
                  const SizedBox(width: 8),
                  _buildThemeCard(
                    theme: FamilyBookCoverTheme.darkRoyal,
                    title: l10n.themeDarkLabel,
                    imageAsset: 'assets/images/bgcard_dark.png',
                  ),
                  const SizedBox(width: 8),
                  _buildThemeCard(
                    theme: FamilyBookCoverTheme.plain,
                    title: l10n.themeBlankLabel,
                    imageAsset: null,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── PHẦN 2: THÔNG TIN TRANG BÌA & TIỀN NHÂN ──
              AppSectionHeader(
                title: l10n.familyBookSectionInfo,
                titleSize: 15,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    AppOutlineTextField(
                      label: l10n.familyBookTitleLabel,
                      controller: _titleController,
                      hintText: l10n.familyBookTitleHint,
                    ),
                    const SizedBox(height: 14),
                    AppOutlineTextField(
                      label: l10n.familyBookFounderLabel,
                      controller: _ancestorController,
                      hintText: l10n.familyBookFounderHint,
                    ),
                    const SizedBox(height: 14),
                    AppOutlineTextField(
                      label: l10n.familyBookLocationLabel,
                      controller: _addressController,
                      hintText: l10n.familyBookLocationHint,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AppOutlineTextField(
                            label: l10n.familyBookEditorLabel,
                            controller: _compilerController,
                            hintText: l10n.familyBookEditorHint,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppOutlineTextField(
                            label: l10n.familyBookYearLabel,
                            controller: _yearController,
                            hintText: l10n.familyBookYearHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── PHẦN 3: LỜI TỰA & GIA HUẤN ──
              AppSectionHeader(
                title: l10n.familyBookSectionPreface,
                titleSize: 15,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              _buildExpandableCard(
                title: l10n.familyBookPrefaceTab,
                controller: _prefaceController,
                defaultText: FamilyBookConfig.defaultPreface,
                l10n: l10n,
              ),
              const SizedBox(height: 10),
              _buildExpandableCard(
                title: l10n.familyBookRulesTab,
                controller: _rulesController,
                defaultText: FamilyBookConfig.defaultClanRules,
                l10n: l10n,
              ),
              const SizedBox(height: 10),
              _buildExpandableCard(
                title: l10n.familyBookMemorialTab,
                controller: _epilogueController,
                defaultText: FamilyBookConfig.defaultEpilogue,
                l10n: l10n,
              ),
              const SizedBox(height: 24),

              // ── PHẦN 4: TÙY CHỌN NỘI DUNG ──
              AppSectionHeader(
                title: l10n.familyBookSectionContent,
                titleSize: 15,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phạm vi thế hệ
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phạm vi thế hệ',
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: context.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Đời ${_config.startGeneration} ➔ Đời ${_config.endGeneration ?? _maxGeneration}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: context.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      subtitle:
                          l10n.familyBookOptTreeChartDesc,
                      value: _config.includeTreeChart,
                      onChanged: (v) =>
                          setState(() => _config.includeTreeChart = v),
                    ),
                    _buildDivider(),

                    // 2. Thống kê
                    _buildSwitchTile(
                      title: l10n.familyBookOptStats,
                      subtitle:
                          l10n.familyBookOptStatsDesc,
                      value: _config.includeStatistics,
                      onChanged: (v) =>
                          setState(() => _config.includeStatistics = v),
                    ),
                    _buildDivider(),

                    // 3. Lịch giỗ
                    _buildSwitchTile(
                      title: l10n.familyBookOptAnniversary,
                      subtitle:
                          l10n.familyBookOptAnniversaryDesc,
                      value: _config.includeMemorialCalendar,
                      onChanged: (v) =>
                          setState(() => _config.includeMemorialCalendar = v),
                    ),
                    _buildDivider(),

                    // 4. Mộ phần
                    _buildSwitchTile(
                      title: l10n.familyBookOptTombs,
                      subtitle:
                          l10n.familyBookOptTombsDesc,
                      value: _config.includeBurialInfo,
                      onChanged: (v) =>
                          setState(() => _config.includeBurialInfo = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ──

  Widget _buildThemeCard({
    required FamilyBookCoverTheme theme,
    required String title,
    required String? imageAsset,
  }) {
    final isSelected = _config.coverTheme == theme;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _config.coverTheme = theme),
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

  Widget _buildExpandableCard({
    required String title,
    required TextEditingController controller,
    required String defaultText,
    required AppLocalizations l10n,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
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
              label: l10n.contentLabel,
              controller: controller,
              maxLines: 5,
              textAlign: TextAlign.justify,
              hintText: l10n.writeContentHint,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    controller.text = defaultText;
                  });
                },
                icon: Icon(
                  LucideIcons.rotateCcw,
                  size: 13,
                  color: context.primary,
                ),
                label: Text(
                  l10n.familyBookResetDefault,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: context.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11,
          color: context.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.accent.withValues(alpha: 0.1),
    );
  }
}
