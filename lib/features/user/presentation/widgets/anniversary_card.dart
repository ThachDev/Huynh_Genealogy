import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../admin/presentation/widgets/events/event_calendar_widget.dart';
import '../models/upcoming_anniversary.dart';
import '../pages/wish_wall_page.dart';
import '../../data/source/wish_api_service.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/widgets.dart';

/// Card dùng cho Ngày Giỗ và Sinh Nhật theo phong cách Lịch Khối bên trái + Thông tin bên phải.
class AnniversaryCard extends StatelessWidget {

  const AnniversaryCard({
    super.key,
    required this.data,
    this.fullWidth = false,
    this.onTap,
  });
  final UpcomingAnniversary data;
  final bool fullWidth;
  final VoidCallback? onTap;

  Future<void> _openWish(BuildContext context) async {
    Navigator.of(context).push(
      SereneFadeSlidePageRoute(
        page: WishWallPage(
          data: data,
          apiService: sl<WishApiService>(),
        ),
      ),
    );
  }

  String _formatDateForCalendar() {
    if (data.targetDate != null) {
      final y = data.targetDate!.year.toString();
      final m = data.targetDate!.month.toString().padLeft(2, '0');
      final d = data.targetDate!.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    }

    // Fallback: tính toán chính xác năm tiếp theo từ ngày hiện tại + daysRemaining
    final target = DateTime.now().add(Duration(days: data.daysRemaining));
    final y = target.year.toString();
    try {
      final parts = data.solarDateLabel.split('/');
      if (parts.length >= 2) {
        final d = parts[0].padLeft(2, '0');
        final m = parts[1].padLeft(2, '0');
        final year = parts.length == 3 ? parts[2] : y;
        return '$year-$m-$d';
      }
    } catch (_) {}
    return '$y-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isBirthday = data.isBirthday;
    final icon = isBirthday ? LucideIcons.cake : LucideIcons.flame;
    final dateStr = _formatDateForCalendar();

    final isToday = data.daysRemaining == 0;
    final countdownText =
        isToday ? l10n.todayLabel : l10n.eventCountdown(data.daysRemaining);

    return InkWell(
      onTap: onTap ?? () => _openWish(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: fullWidth ? double.infinity : 260,
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.textSecondary.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: context.isDarkMode ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ── Bên trái: Lịch Khối EventCalendarWidget (Hỗ trợ Âm/Dương) ──
            SizedBox(
              width: 58,
              height: 68,
              child: EventCalendarWidget(
                eventDate: dateStr,
                primaryColor: context.primary,
                lunarColor: context.accent,
              ),
            ),

            const SizedBox(width: 14),

            // ── Bên phải: Tên + Thế hệ/Mô tả + Countdown Badge ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tên người
                  Text(
                    data.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Đời thứ ... hoặc ngày âm lịch nếu có
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 13,
                        color: context.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.member.generation != null
                              ? l10n.generationLabel('${data.member.generation!}')
                              : (data.lunarDateLabel ??
                                  (isBirthday
                                      ? l10n.memberBirthdayLabel
                                      : l10n.deathAnniversaryMemorialLabel)),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isToday
                            ? LucideIcons.circleDot
                            : LucideIcons.alarmClock,
                        size: 12,
                        color: context.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        countdownText,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: context.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
