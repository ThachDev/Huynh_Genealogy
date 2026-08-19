import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../events/events.dart';

/// Card sự kiện kiểu compact — thumbnail 84×84 bên trái, nội dung bên phải.
/// Dùng trong AdminEventsListPage.
class EventItemCard extends StatelessWidget {

  const EventItemCard({
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

  // ── Thumbnail ────────────────────────────────────────────────
  Widget _thumbnail(BuildContext context) {
    final imageUrl = event.imageUrl;
    final isNetwork = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocal =
        imageUrl != null && !isNetwork && File(imageUrl).existsSync();

    final Widget placeholder = Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          LucideIcons.calendarDays,
          size: 26,
          color: context.primary.withValues(alpha: 0.45),
        ),
      ),
    );

    if (isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AppNetworkImage(
          url: imageUrl,
          width: 84,
          height: 84,
          errorBuilder: (_) => placeholder,
        ),
      );
    }

    if (isLocal) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(imageUrl),
          width: 84,
          height: 84,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }

    return placeholder;
  }

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
            color: context.textSecondary.withValues(alpha: 0.14),
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
            // ── Thumbnail ──
            _thumbnail(context),
            const SizedBox(width: 12),

            // ── Text content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title (Tiêu đề sự kiện)
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

                  // Content / Description (Nội dung maxline 2 dòng)
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

                  // Bottom row: Người đăng + Ngày diễn ra
                  Row(
                    children: [
                      // Người đăng
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

                      const Spacer(),

                      // Ngày diễn ra
                      Icon(LucideIcons.clock3,
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        event.eventDate,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                      if (event.isLunar) ...[
                        const SizedBox(width: 4),
                        Text(
                          l10n.lunarShortLabel,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.accent,
                          ),
                        ),
                      ],
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
