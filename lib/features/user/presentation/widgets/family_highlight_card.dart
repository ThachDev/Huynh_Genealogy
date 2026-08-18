import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';

/// Card Banner Tiêu Điểm Dòng Họ (Sự kiện / Lễ giỗ gần nhất).
/// Sử dụng `TraditionalOrnamentalCard` để tạo khung viền hoa văn trang nghiêm.
class FamilyHighlightCard extends StatelessWidget {
  final String title;
  final String dateLabel;
  final String? subtitle;
  final int daysRemaining;
  final bool isAnniversary;
  final VoidCallback? onTap;

  const FamilyHighlightCard({
    super.key,
    required this.title,
    required this.dateLabel,
    this.subtitle,
    required this.daysRemaining,
    this.isAnniversary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: TraditionalOrnamentalCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          borderColor: context.accent.withValues(alpha: 0.35),
          fillColor: context.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header: Tag Tiêu Điểm + Countdown Badge ──
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAnniversary
                          ? const Color(0xFFD97706).withValues(alpha: 0.12)
                          : context.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAnniversary ? LucideIcons.flame : LucideIcons.sparkles,
                          size: 13,
                          color: isAnniversary
                              ? const Color(0xFFD97706)
                              : context.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          (isAnniversary
                                  ? l10n.deathAnniversariesSectionTitle
                                  : l10n.eventsListTitle)
                              .toUpperCase(),
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isAnniversary
                                ? const Color(0xFFD97706)
                                : context.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Countdown badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: context.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.alarmClock,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          daysRemaining == 0
                              ? l10n.todayLabel
                              : l10n.eventCountdown(daysRemaining),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Title & Date ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                            height: 1.25,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null && subtitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Date tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: context.textSecondary.withValues(alpha: 0.12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.calendar,
                            size: 13, color: context.accent),
                        const SizedBox(width: 5),
                        Text(
                          dateLabel,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
