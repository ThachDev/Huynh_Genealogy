import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../events/events.dart';
import 'event_calendar_widget.dart';

/// Card thông báo — hiển thị block lịch thông minh (chuyển đổi Âm/Dương) bên trái,
/// bên phải: Tiêu đề -> Nội dung (tối đa 2 dòng) -> Người thông báo.
class AnnouncementItemCard extends StatelessWidget {

  const AnnouncementItemCard({
    super.key,
    required this.event,
    required this.canEdit,
    required this.onTap,
    required this.onDelete,
  });
  final EventEntity event;
  final bool canEdit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ── Launcher Cuốn Lịch (Âm / Dương khi tap) ──
            SizedBox(
              width: 74,
              height: 82,
              child: EventCalendarWidget(
                eventDate: event.eventDate,
                isLunarDefault: event.isLunar,
                l10n: l10n,
              ),
            ),
            const SizedBox(width: 12),

            // ── Text content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title (Tiêu đề thông báo)
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  // Description / Content (Nội dung thông báo tối đa 2 line)
                  Builder(
                    builder: (context) {
                      final displayContent = (event.content != null &&
                              event.content!.trim().isNotEmpty)
                          ? event.content!.trim()
                          : (event.description != null &&
                                  event.description!.trim().isNotEmpty)
                              ? event.description!.trim()
                              : null;

                      if (displayContent == null) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          displayContent,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: context.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // Người thông báo
                  Row(
                    children: [
                      Icon(LucideIcons.user,
                          size: 12, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          event.organizer ?? l10n.adminBoard,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: context.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
