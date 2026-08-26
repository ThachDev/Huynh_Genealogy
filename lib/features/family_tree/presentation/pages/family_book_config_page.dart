import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
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
    return Scaffold(
      appBar: AppAppBar(
        title: 'Thiết Lập Xuất Bản Gia Phả',
        actions: [
          IconButton(
            tooltip: 'Xem trước PDF',
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
              const AppSectionHeader(
                title: '1. Phong Cách Giao Diện & Bìa Sách',
                titleSize: 15,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildThemeCard(
                    theme: FamilyBookCoverTheme.lightTraditional,
                    title: 'Chủ đề sáng',
                    imageAsset: 'assets/images/bgcard_light.png',
                  ),
                  const SizedBox(width: 8),
                  _buildThemeCard(
                    theme: FamilyBookCoverTheme.darkRoyal,
                    title: 'Chủ đề tối',
                    imageAsset: 'assets/images/bgcard_dark.png',
                  ),
                  const SizedBox(width: 8),
                  _buildThemeCard(
                    theme: FamilyBookCoverTheme.plain,
                    title: 'Để trống',
                    imageAsset: null,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── PHẦN 2: THÔNG TIN TRANG BÌA & TIỀN NHÂN ──
              const AppSectionHeader(
                title: '2. Thông Tin Ấn Phẩm & Tiền Nhân',
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
                      label: 'Tiêu đề ấn phẩm gia phả',
                      controller: _titleController,
                      hintText: 'VD: PHẢ HỆ ĐẠI TÔN HỌ NGUYỄN',
                    ),
                    const SizedBox(height: 14),
                    AppOutlineTextField(
                      label: 'Danh tính Cụ Thủy Tổ / Khởi Tổ',
                      controller: _ancestorController,
                      hintText: 'VD: Thủy Tổ: Nguyễn Văn A',
                    ),
                    const SizedBox(height: 14),
                    AppOutlineTextField(
                      label: 'Địa danh Từ Đường / Quê quán phát tích',
                      controller: _addressController,
                      hintText:
                          'VD: Từ Đường Họ Nguyễn, Xã..., Huyện..., Tỉnh...',
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AppOutlineTextField(
                            label: 'Ban / Người biên soạn',
                            controller: _compilerController,
                            hintText: 'VD: Hội Đồng Gia Tộc',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AppOutlineTextField(
                            label: 'Thời gian biên soạn',
                            controller: _yearController,
                            hintText: 'VD: Năm Bính Ngọ 2026',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── PHẦN 3: LỜI TỰA & GIA HUẤN ──
              const AppSectionHeader(
                title: '3. Lời Tựa & Gia Huấn Dòng Tộc',
                titleSize: 15,
                indicatorHeight: 16,
              ),
              const SizedBox(height: 10),
              _buildExpandableCard(
                title: 'Lời Nói Đầu Cội Nguồn',
                controller: _prefaceController,
                defaultText: FamilyBookConfig.defaultPreface,
              ),
              const SizedBox(height: 10),
              _buildExpandableCard(
                title: 'Tộc Ước & Gia Quy Tiên Tổ',
                controller: _rulesController,
                defaultText: FamilyBookConfig.defaultClanRules,
              ),
              const SizedBox(height: 10),
              _buildExpandableCard(
                title: 'Khắc Ghi Tri Ân Hậu Thế',
                controller: _epilogueController,
                defaultText: FamilyBookConfig.defaultEpilogue,
              ),
              const SizedBox(height: 24),

              // ── PHẦN 4: TÙY CHỌN NỘI DUNG ──
              const AppSectionHeader(
                title: '4. Tùy Chọn Nội Dung Xuất Bản',
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
                      title: 'Sơ đồ cây gia phả trực quan',
                      subtitle:
                          'Sơ đồ phân nhánh thế thứ kết nối các thế hệ dòng họ',
                      value: _config.includeTreeChart,
                      onChanged: (v) =>
                          setState(() => _config.includeTreeChart = v),
                    ),
                    _buildDivider(),

                    // 2. Thống kê
                    _buildSwitchTile(
                      title: 'Bảng thống kê nhân khẩu',
                      subtitle:
                          'Tổng hợp số đời, nam đinh, nữ giới, dâu hiền, sinh tử',
                      value: _config.includeStatistics,
                      onChanged: (v) =>
                          setState(() => _config.includeStatistics = v),
                    ),
                    _buildDivider(),

                    // 3. Lịch giỗ
                    _buildSwitchTile(
                      title: 'Lịch giỗ 12 tháng Âm lịch',
                      subtitle:
                          'Bảng tổng hợp ngày kỵ nhật chư vị tôn linh trong năm',
                      value: _config.includeMemorialCalendar,
                      onChanged: (v) =>
                          setState(() => _config.includeMemorialCalendar = v),
                    ),
                    _buildDivider(),

                    // 4. Mộ phần
                    _buildSwitchTile(
                      title: 'Ghi chú mộ phần',
                      subtitle:
                          'Hiển thị thông tin nơi an táng của các bậc tiền nhân',
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
          title: Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
          children: [
            AppOutlineTextField(
              label: 'Nội dung',
              controller: controller,
              maxLines: 5,
              textAlign: TextAlign.justify,
              hintText: 'Nhập nội dung...',
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
                  'Khôi phục văn mẫu',
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
