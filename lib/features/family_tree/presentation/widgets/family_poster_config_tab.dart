import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/models/family_book_config.dart';
import '../../domain/models/family_tree_poster_config.dart';
import 'family_book_config_shared_widgets.dart';

/// Tab cấu hình xuất Phả Đồ (Tranh cỡ lớn treo tường A0-A4)
class FamilyPosterConfigTab extends StatelessWidget {
  const FamilyPosterConfigTab({
    super.key,
    required this.posterConfig,
    required this.maxGeneration,
    required this.posterTitleController,
    required this.posterLeftCoupletController,
    required this.posterRightCoupletController,
    required this.onConfigChanged,
  });

  final FamilyTreePosterConfig posterConfig;
  final int maxGeneration;
  final TextEditingController posterTitleController;
  final TextEditingController posterLeftCoupletController;
  final TextEditingController posterRightCoupletController;
  final VoidCallback onConfigChanged;

  Widget _buildPaperSizeSegment(
    BuildContext context,
    PosterPaperSize size,
    String label,
  ) {
    final isSelected = posterConfig.paperSize == size;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          posterConfig.paperSize = size;
          onConfigChanged();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? context.primary
                : context.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? context.primary
                  : context.accent.withValues(alpha: 0.15),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : context.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getPaperSizeDescription(
      PosterPaperSize size, AppLocalizations l10n) {
    switch (size) {
      case PosterPaperSize.a0:
        return l10n.familyPosterPaperA0Desc;
      case PosterPaperSize.a1:
        return l10n.familyPosterPaperA1Desc;
      case PosterPaperSize.a2:
        return l10n.familyPosterPaperA2Desc;
      case PosterPaperSize.a3:
        return l10n.familyPosterPaperA3Desc;
      case PosterPaperSize.a4:
        return l10n.familyPosterPaperA4Desc;
    }
  }

  Widget _buildOrientationSegment(
    BuildContext context, {
    required PosterOrientation orientation,
    required String title,
    required IconData icon,
  }) {
    final isSelected = posterConfig.orientation == orientation;

    return GestureDetector(
      onTap: () {
        posterConfig.orientation = orientation;
        onConfigChanged();
      },
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── MỤC 1: KHỔ IN & CHIỀU TRANH ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.scaling,
            title: l10n.familyPosterSectionPaper,
          ),
          const SizedBox(height: 12),
          buildBookConfigCardWrapper(
            context,
            children: [
              Text(
                l10n.familyPosterPaperSize,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPaperSizeSegment(context, PosterPaperSize.a0, 'A0'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(context, PosterPaperSize.a1, 'A1'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(context, PosterPaperSize.a2, 'A2'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(context, PosterPaperSize.a3, 'A3'),
                  const SizedBox(width: 6),
                  _buildPaperSizeSegment(context, PosterPaperSize.a4, 'A4'),
                ],
              ),
              const SizedBox(height: 8),
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
                        _getPaperSizeDescription(posterConfig.paperSize, l10n),
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
              buildBookConfigDivider(context),
              Text(
                l10n.familyPosterOrientation,
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
                      context,
                      orientation: PosterOrientation.landscape,
                      title: l10n.familyPosterOrientationLandscape,
                      icon: LucideIcons.layoutGrid,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildOrientationSegment(
                      context,
                      orientation: PosterOrientation.portrait,
                      title: l10n.familyPosterOrientationPortrait,
                      icon: LucideIcons.fileText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 2: PHONG CÁCH NỀN & KHUNG TRANH ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.palette,
            title: l10n.familyPosterSectionStyle,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              buildBookConfigThemeCard(
                context,
                theme: FamilyBookCoverTheme.lightTraditional,
                title: l10n.themeLightLabel,
                imageAsset: 'assets/images/bgcard_light.png',
                currentTheme: posterConfig.posterTheme,
                onSelect: (t) {
                  posterConfig.posterTheme = t;
                  onConfigChanged();
                },
              ),
              const SizedBox(width: 8),
              buildBookConfigThemeCard(
                context,
                theme: FamilyBookCoverTheme.darkRoyal,
                title: l10n.themeDarkLabel,
                imageAsset: 'assets/images/bgcard_dark.png',
                currentTheme: posterConfig.posterTheme,
                onSelect: (t) {
                  posterConfig.posterTheme = t;
                  onConfigChanged();
                },
              ),
              const SizedBox(width: 8),
              buildBookConfigThemeCard(
                context,
                theme: FamilyBookCoverTheme.plain,
                title: l10n.themeBlankLabel,
                imageAsset: null,
                currentTheme: posterConfig.posterTheme,
                onSelect: (t) {
                  posterConfig.posterTheme = t;
                  onConfigChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 3: TIÊU ĐỀ & CÂU ĐỐI NHÀ THỜ HỌ ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.scroll,
            title: l10n.familyPosterSectionTitleCouplet,
          ),
          const SizedBox(height: 12),
          buildBookConfigCardWrapper(
            context,
            children: [
              AppOutlineTextField(
                controller: posterTitleController,
                label: l10n.familyPosterTitleLabel,
                hintText: l10n.familyPosterTitleHint,
                prefixIcon: const Icon(LucideIcons.type, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: posterLeftCoupletController,
                label: l10n.familyPosterCoupletLeftLabel,
                hintText: l10n.familyPosterCoupletLeftHint,
                prefixIcon: const Icon(LucideIcons.alignLeft, size: 18),
              ),
              const SizedBox(height: 14),
              AppOutlineTextField(
                controller: posterRightCoupletController,
                label: l10n.familyPosterCoupletRightLabel,
                hintText: l10n.familyPosterCoupletRightHint,
                prefixIcon: const Icon(LucideIcons.alignRight, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── MỤC 4: PHẠM VI & TÙY CHỌN HIỂN THỊ ──
          buildBookConfigSectionHeader(
            context,
            icon: LucideIcons.slidersHorizontal,
            title: l10n.familyPosterSectionScope,
          ),
          const SizedBox(height: 12),
          buildBookConfigCardWrapper(
            context,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.familyPosterScopeGenerations,
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
                      l10n.familyBookScopeGenerationsRange(
                        posterConfig.startGeneration,
                        posterConfig.endGeneration ?? maxGeneration,
                      ),
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
                  posterConfig.startGeneration.toDouble(),
                  (posterConfig.endGeneration ?? maxGeneration).toDouble(),
                ),
                min: 1,
                max: maxGeneration > 1 ? maxGeneration.toDouble() : 2,
                divisions: maxGeneration > 1 ? maxGeneration - 1 : 1,
                activeColor: context.primary,
                inactiveColor: context.accent.withValues(alpha: 0.25),
                onChanged: (values) {
                  posterConfig.startGeneration = values.start.round();
                  posterConfig.endGeneration = values.end.round();
                  onConfigChanged();
                },
              ),
              buildBookConfigDivider(context),

              // Hiển thị phối ngẫu
              buildBookConfigSwitchTile(
                context,
                title: l10n.familyPosterIncludeSpouse,
                subtitle: l10n.familyPosterIncludeSpouseDesc,
                value: posterConfig.includeSpouse,
                onChanged: (v) {
                  posterConfig.includeSpouse = v;
                  onConfigChanged();
                },
              ),
              buildBookConfigDivider(context),

              // Hiển thị năm sinh / mất
              buildBookConfigSwitchTile(
                context,
                title: l10n.familyPosterIncludeDates,
                subtitle: l10n.familyPosterIncludeDatesDesc,
                value: posterConfig.includeDates,
                onChanged: (v) {
                  posterConfig.includeDates = v;
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
