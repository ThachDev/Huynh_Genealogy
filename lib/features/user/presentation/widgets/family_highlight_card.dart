import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../admin/presentation/widgets/events/event_calendar_widget.dart';

// ── Loại sự kiện ─────────────────────────────────────────────────────────────
enum HighlightEventType {
  event,       // Sự kiện dòng tộc
  birthday,    // Sinh nhật
  anniversary, // Lễ giỗ / Ngày mất
}

// ═════════════════════════════════════════════════════════════════════════════
/// Card Banner Tiêu Điểm Dòng Họ – Thiết kế hiện đại, tinh gọn, lịch âm/dương linh hoạt.
// ═════════════════════════════════════════════════════════════════════════════
class FamilyHighlightCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? location;
  final DateTime? date;
  final String dateLabel;
  final String? lunarDateLabel;
  final int daysRemaining;
  final HighlightEventType eventType;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const FamilyHighlightCard({
    super.key,
    required this.title,
    this.description,
    this.location,
    this.date,
    required this.dateLabel,
    this.lunarDateLabel,
    required this.daysRemaining,
    this.eventType = HighlightEventType.event,
    this.onTap,
    this.onActionTap,
  });

  bool get _isToday => daysRemaining == 0;

  // ── Cấu hình màu + nhãn theo loại ──────────────────────────────────────
  ({
    Color primary,
    Color secondary,
    Color bgLight,
    IconData headerIcon,
    IconData ctaIcon,
    String typeLabel,
    String ctaLabel,
  }) _cfg(BuildContext ctx, AppLocalizations l10n) {
    switch (eventType) {
      case HighlightEventType.event:
        return (
          primary: ctx.primary,
          secondary: ctx.primary.withValues(alpha: 0.72),
          bgLight: ctx.primary.withValues(alpha: 0.06),
          headerIcon: LucideIcons.calendarDays,
          ctaIcon: LucideIcons.arrowRight,
          typeLabel: l10n.highlightTypeEventLabel,
          ctaLabel: l10n.viewEventDetailsLabel,
        );
      case HighlightEventType.birthday:
        return (
          primary: ctx.primary,
          secondary: ctx.primary.withValues(alpha: 0.72),
          bgLight: ctx.primary.withValues(alpha: 0.06),
          headerIcon: LucideIcons.cake,
          ctaIcon: LucideIcons.heart,
          typeLabel: l10n.highlightTypeBirthdayLabel,
          ctaLabel: l10n.sendBirthdayWishLabel,
        );
      case HighlightEventType.anniversary:
        return (
          primary: ctx.primary,
          secondary: ctx.primary.withValues(alpha: 0.72),
          bgLight: ctx.primary.withValues(alpha: 0.06),
          headerIcon: LucideIcons.flame,
          ctaIcon: LucideIcons.flame,
          typeLabel: l10n.deathAnniversariesSectionTitle.toUpperCase(),
          ctaLabel: l10n.lightIncenseLabel,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cfg = _cfg(context, l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cfg.primary.withValues(alpha: 0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Strip: Icon + Title bên trái, Countdown / Hôm nay bên phải
            _buildHeader(cfg, l10n, context),

            // 2. Body: Bên trái là Lịch hệ thống (EventCalendarWidget) - Bên phải là Cột (Tên + Des + Địa điểm)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
                child: _buildBody(cfg, context),
              ),
            ),

            // 3. Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Divider(
                height: 1,
                thickness: 0.6,
                color: cfg.primary.withValues(alpha: 0.12),
              ),
            ),

            // 4. Footer CTA Button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
              child: _buildCta(cfg, context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header strip ───────────────────────────────────────────────────────
  Widget _buildHeader(
    ({
      Color primary,
      Color secondary,
      Color bgLight,
      IconData headerIcon,
      IconData ctaIcon,
      String typeLabel,
      String ctaLabel,
    }) cfg,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: cfg.primary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(cfg.headerIcon, size: 14, color: Colors.white.withValues(alpha: 0.95)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              cfg.typeLabel,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.6,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Countdown / Hôm nay badge (Bỏ background)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isToday ? LucideIcons.circleDot : LucideIcons.alarmClock,
                size: 11,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                _isToday
                    ? l10n.todayLabel
                    : l10n.eventCountdown(daysRemaining),
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Body: Lịch bên trái (EventCalendarWidget) + Chi tiết bên phải ──────
  Widget _buildBody(
    ({
      Color primary,
      Color secondary,
      Color bgLight,
      IconData headerIcon,
      IconData ctaIcon,
      String typeLabel,
      String ctaLabel,
    }) cfg,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Widget Lịch có sẵn của hệ thống (hỗ trợ chuyển đổi Âm / Dương lịch)
        SizedBox(
          width: 64,
          height: 74,
          child: EventCalendarWidget(
            eventDate: date != null
                ? '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}'
                : dateLabel,
            isLunarDefault: eventType == HighlightEventType.anniversary,
            primaryColor: cfg.primary,
            lunarColor: eventType == HighlightEventType.birthday ? context.accent : (eventType == HighlightEventType.anniversary ? context.accent : context.accent),
          ),
        ),

        const SizedBox(width: 12),

        // Cột thông tin: Tên sự kiện + Des title (max 2 dòng) + Địa điểm
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tên sự kiện
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                  height: 1.25,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Description (mô tả - max 2 lines)
              if (description != null &&
                  description!.trim().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  description!.trim(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textSecondary,
                    height: 1.35,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Địa điểm (Location)
              if (location != null &&
                  location!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      LucideIcons.mapPin,
                      size: 12,
                      color: cfg.primary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location!.trim(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Footer CTA Button ───────────────────────────────────────────────────
  Widget _buildCta(
    ({
      Color primary,
      Color secondary,
      Color bgLight,
      IconData headerIcon,
      IconData ctaIcon,
      String typeLabel,
      String ctaLabel,
    }) cfg,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onActionTap ?? onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: cfg.primary.withValues(alpha: 0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cfg.primary.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(cfg.ctaIcon, size: 14, color: cfg.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  cfg.ctaLabel,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: cfg.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
