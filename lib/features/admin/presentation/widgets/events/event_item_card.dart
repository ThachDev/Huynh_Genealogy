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
  final EventEntity event;
  final bool canEdit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const EventItemCard({
    super.key,
    required this.event,
    required this.canEdit,
    required this.onTap,
    required this.onDelete,
  });

  // ── Status helpers ────────────────────────────────────────────
  String _getStatus() {
    try {
      final now = DateTime.now();
      final date = DateTime.parse(event.eventDate);
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return 'active';
      } else if (date.isAfter(now)) {
        return 'upcoming';
      } else {
        return 'past';
      }
    } catch (_) {
      return 'past';
    }
  }

  // ── Thumbnail ────────────────────────────────────────────────
  Widget _thumbnail(BuildContext context) {
    final imageUrl = event.imageUrl;
    final isNetwork = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocal =
        imageUrl != null && !isNetwork && File(imageUrl).existsSync();

    Widget placeholder = Container(
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
          fit: BoxFit.cover,
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

  // ── Status badge ─────────────────────────────────────────────
  Widget _statusBadge(String status, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color color;
    final String text;

    switch (status) {
      case 'active':
        color = context.primary;
        text = l10n.eventOngoing;
        break;
      case 'upcoming':
        color = Colors.amber.shade700;
        text = l10n.eventUpcoming;
        break;
      default:
        color = context.textSecondary;
        text = l10n.eventEnded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
      ),
      child: Text(
        text,
        style: GoogleFonts.beVietnamPro(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = _getStatus();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──
            _thumbnail(context),
            const SizedBox(width: 12),

            // ── Text content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status + Date row
                  Row(
                    children: [
                      _statusBadge(status, context),
                      if (event.isLunar) ...[
                        const SizedBox(width: 6),
                        Text(
                          l10n.lunarShortLabel,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.accent,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Icon(LucideIcons.clock3,
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        event.eventDate,
                        style: GoogleFonts.inter(
                            fontSize: 11, color: context.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Organizer + Location
                  Row(
                    children: [
                      Icon(LucideIcons.user,
                          size: 11, color: context.textSecondary),
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
                      if (event.location != null &&
                          event.location!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text('·',
                              style: TextStyle(
                                  color: context.textSecondary, fontSize: 11)),
                        ),
                        Icon(LucideIcons.mapPin,
                            size: 11, color: context.textSecondary),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            event.location!,
                            style: GoogleFonts.inter(
                                fontSize: 11, color: context.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
