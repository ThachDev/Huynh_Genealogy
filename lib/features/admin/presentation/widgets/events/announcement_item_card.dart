import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../core/widgets/app_network_image.dart';
import '../../../../events/events.dart';

/// Card thông báo kiểu compact — thumbnail/avatar bên trái, nội dung bên phải.
/// Màu đồng bộ với design system (context.primary / crimson).
class AnnouncementItemCard extends StatelessWidget {
  final EventEntity event;
  final bool canEdit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AnnouncementItemCard({
    super.key,
    required this.event,
    required this.canEdit,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDate() {
    if (event.eventDate.isEmpty) return '';
    try {
      final parts = event.eventDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return event.eventDate;
  }

  // ── Avatar / Thumbnail ────────────────────────────────────────
  Widget _buildAvatar(BuildContext context) {
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
        border: Border.all(
          color: context.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          LucideIcons.megaphone,
          size: 26,
          color: context.primary.withValues(alpha: 0.5),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.primary.withValues(alpha: 0.12),
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
            // ── Avatar / thumbnail ──
            _buildAvatar(context),
            const SizedBox(width: 12),

            // ── Text content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge + Date row
                  Row(
                    children: [
                      // Thông báo badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: context.primary.withValues(alpha: 0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          l10n.announcementBadge,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(LucideIcons.clock3,
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        _formatDate(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
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

                  // Description
                  if (event.description != null &&
                      event.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Organizer
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
