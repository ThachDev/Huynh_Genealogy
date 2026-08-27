import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/models/family_book_config.dart';
import 'family_book_config_shared_widgets.dart';

/// Tab cấu hình Sách Phả Ký (A4)
class FamilyBookConfigTab extends StatelessWidget {
  const FamilyBookConfigTab({
    super.key,
    required this.config,
    required this.maxGeneration,
    required this.titleController,
    required this.ancestorController,
    required this.addressController,
    required this.compilerController,
    required this.yearController,
    required this.prefaceController,
    required this.rulesController,
    required this.epilogueController,
    required this.onConfigChanged,
  });

  final FamilyBookConfig config;
  final int maxGeneration;
  final TextEditingController titleController;
  final TextEditingController ancestorController;
  final TextEditingController addressController;
  final TextEditingController compilerController;
  final TextEditingController yearController;
  final TextEditingController prefaceController;
  final TextEditingController rulesController;
  final TextEditingController epilogueController;
  final VoidCallback onConfigChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── MỤC 1: PHONG CÁCH GIAO DIỆN & BÌA SÁCH ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.palette,
            title: l10n.familyBookSectionStyle,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              buildBookConfigThemeCard(
                context,
                theme: FamilyBookCoverTheme.lightTraditional,
                title: l10n.themeLightLabel,
                imageAsset: 'assets/images/bgcard_light.png',
                currentTheme: config.coverTheme,
                onSelect: (t) {
                  config.coverTheme = t;
                  onConfigChanged();
                },
              ),
              const SizedBox(width: 8),
              buildBookConfigThemeCard(
                context,
                theme: FamilyBookCoverTheme.darkRoyal,
                title: l10n.themeDarkLabel,
                imageAsset: 'assets/images/bgcard_dark.png',
                currentTheme: config.coverTheme,
                onSelect: (t) {
                  config.coverTheme = t;
                  onConfigChanged();
                },
              ),
              const SizedBox(width: 8),
              buildBookConfigThemeCard(
                context,
                theme: FamilyBookCoverTheme.plain,
                title: l10n.themeBlankLabel,
                imageAsset: null,
                currentTheme: config.coverTheme,
                onSelect: (t) {
                  config.coverTheme = t;
                  onConfigChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 2: THÔNG TIN ẤN PHẨM & TIỀN NHÂN ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.bookMarked,
            title: l10n.familyBookSectionInfo,
          ),
          const SizedBox(height: 12),
          buildBookConfigCardWrapper(
            context,
            children: [
              AppOutlineTextField(
                controller: titleController,
                label: l10n.familyBookTitleLabel,
                hintText: l10n.familyBookTitleHint,
                prefixIcon: const Icon(LucideIcons.type, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: ancestorController,
                label: l10n.familyBookFounderLabel,
                hintText: l10n.familyBookFounderHint,
                prefixIcon: const Icon(LucideIcons.crown, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: addressController,
                label: l10n.familyBookLocationLabel,
                hintText: l10n.familyBookLocationHint,
                prefixIcon: const Icon(LucideIcons.mapPin, size: 18),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: AppOutlineTextField(
                      controller: compilerController,
                      label: l10n.familyBookEditorLabel,
                      hintText: l10n.familyBookEditorHint,
                      prefixIcon: const Icon(LucideIcons.userCheck, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppOutlineTextField(
                      controller: yearController,
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
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.feather,
            title: l10n.familyBookSectionPreface,
          ),
          const SizedBox(height: 12),
          buildBookConfigCardWrapper(
            context,
            padding: EdgeInsets.zero,
            children: [
              buildBookConfigExpandableEditor(
                context,
                icon: LucideIcons.bookOpen,
                title: l10n.familyBookPrefaceTab,
                controller: prefaceController,
                defaultText: FamilyBookConfig.defaultPreface,
                isInitiallyExpanded: true,
              ),
              buildBookConfigDivider(context),
              buildBookConfigExpandableEditor(
                context,
                icon: LucideIcons.shieldCheck,
                title: l10n.familyBookRulesTab,
                controller: rulesController,
                defaultText: FamilyBookConfig.defaultClanRules,
              ),
              buildBookConfigDivider(context),
              buildBookConfigExpandableEditor(
                context,
                icon: LucideIcons.heartHandshake,
                title: l10n.familyBookMemorialTab,
                controller: epilogueController,
                defaultText: FamilyBookConfig.defaultEpilogue,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 4: TÙY CHỌN NỘI DUNG XUẤT BẢN ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.slidersHorizontal,
            title: l10n.familyBookSectionContent,
          ),
          const SizedBox(height: 12),
          buildBookConfigCardWrapper(
            context,
            children: [
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
                      'Đời ${config.startGeneration} - Đời ${config.endGeneration ?? maxGeneration}',
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
                  config.startGeneration.toDouble(),
                  (config.endGeneration ?? maxGeneration).toDouble(),
                ),
                min: 1,
                max: maxGeneration > 1 ? maxGeneration.toDouble() : 2,
                divisions: maxGeneration > 1 ? maxGeneration - 1 : 1,
                activeColor: context.primary,
                inactiveColor: context.accent.withValues(alpha: 0.25),
                onChanged: (values) {
                  config.startGeneration = values.start.round();
                  config.endGeneration = values.end.round();
                  onConfigChanged();
                },
              ),
              buildBookConfigDivider(context),

              // 1. Cây gia phả
              buildBookConfigSwitchTile(
                context,
                title: l10n.familyBookOptTreeChart,
                subtitle: l10n.familyBookOptTreeChartDesc,
                value: config.includeTreeChart,
                onChanged: (v) {
                  config.includeTreeChart = v;
                  onConfigChanged();
                },
              ),
              buildBookConfigDivider(context),

              // 2. Thống kê
              buildBookConfigSwitchTile(
                context,
                title: l10n.familyBookOptStats,
                subtitle: l10n.familyBookOptStatsDesc,
                value: config.includeStatistics,
                onChanged: (v) {
                  config.includeStatistics = v;
                  onConfigChanged();
                },
              ),
              buildBookConfigDivider(context),

              // 3. Lịch giỗ
              buildBookConfigSwitchTile(
                context,
                title: l10n.familyBookOptAnniversary,
                subtitle: l10n.familyBookOptAnniversaryDesc,
                value: config.includeMemorialCalendar,
                onChanged: (v) {
                  config.includeMemorialCalendar = v;
                  onConfigChanged();
                },
              ),
              buildBookConfigDivider(context),

              // 4. Mộ phần
              buildBookConfigSwitchTile(
                context,
                title: l10n.familyBookOptTombs,
                subtitle: l10n.familyBookOptTombsDesc,
                value: config.includeBurialInfo,
                onChanged: (v) {
                  config.includeBurialInfo = v;
                  onConfigChanged();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
