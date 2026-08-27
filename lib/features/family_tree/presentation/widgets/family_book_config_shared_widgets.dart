import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/models/family_book_config.dart';

/// Tiêu đề phân đoạn form
Widget buildBookConfigSectionHeader(
  BuildContext context, {
  required IconData icon,
  required String title,
}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: context.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: context.primary),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: context.textPrimary,
          letterSpacing: 0.2,
        ),
      ),
    ],
  );
}

/// Khung bọc Card bo góc
Widget buildBookConfigCardWrapper(
  BuildContext context, {
  required List<Widget> children,
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
}) {
  return Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: context.accent.withValues(alpha: 0.15),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

/// Đường kẻ phân cách nhẹ
Widget buildBookConfigDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Divider(
      height: 1,
      thickness: 1,
      color: context.accent.withValues(alpha: 0.1),
    ),
  );
}

/// Switch cấu hình bật/tắt
Widget buildBookConfigSwitchTile(
  BuildContext context, {
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
              style: GoogleFonts.inter(
                fontSize: 11.5,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
      Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: context.primary,
        activeTrackColor: context.primary.withValues(alpha: 0.35),
      ),
    ],
  );
}

/// Editor văn bản có thể mở rộng (Lời tựa, Gia huấn, ...)
Widget buildBookConfigExpandableEditor(
  BuildContext context, {
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
      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      leading: Icon(icon, size: 18, color: context.primary),
      title: Text(
        title,
        style: GoogleFonts.beVietnamPro(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => controller.text = defaultText,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.familyBookStandardSample,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.primary,
              ),
            ),
          ),
          const Icon(LucideIcons.chevronDown, size: 18),
        ],
      ),
      children: [
        TextField(
          controller: controller,
          maxLines: 8,
          style: GoogleFonts.inter(fontSize: 13, height: 1.5),
          decoration: InputDecoration(
            isDense: true,
            hintText: l10n.familyBookInputContentHint,
            hintStyle: GoogleFonts.inter(
              fontSize: 12,
              color: context.textSecondary.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: context.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.accent.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.accent.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: context.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Thẻ chọn Theme bìa sách/tranh
Widget buildBookConfigThemeCard(
  BuildContext context, {
  required FamilyBookCoverTheme theme,
  required String title,
  required String? imageAsset,
  required FamilyBookCoverTheme currentTheme,
  required ValueChanged<FamilyBookCoverTheme> onSelect,
}) {
  final l10n = AppLocalizations.of(context);
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
                          color: context.resolve(
                            const Color(0xFFFBF8F1),
                            const Color(0xFF232323),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.5),
                              width: 0.8,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.accent.withValues(alpha: 0.25),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.scroll,
                                    size: 16,
                                    color: context.primary,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.familyBookThemePlainShort,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                      color: context.primary,
                                    ),
                                  ),
                                  Text(
                                    l10n.familyBookArtBorder,
                                    style: GoogleFonts.inter(
                                      fontSize: 6.5,
                                      color: context.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? context.primary : context.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}
