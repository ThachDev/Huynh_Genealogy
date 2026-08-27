import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
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
              'Mẫu chuẩn',
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
            hintText: 'Nhập nội dung...',
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
                      Container(
                        decoration: BoxDecoration(
                          color: context.primary.withValues(alpha: 0.2),
                          border: Border.all(
                            color: context.primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: context.primary,
                            child: const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.white,
                            ),
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
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? context.primary : context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
