import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../events/events.dart';

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

  Widget _buildThumbnail(BuildContext context, Color accentColor) {
    final imageUrl = event.imageUrl;
    final isNetwork = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocal =
        imageUrl != null && !isNetwork && File(imageUrl).existsSync();

    Widget placeholder = Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          LucideIcons.megaphone,
          size: 28,
          color: accentColor,
        ),
      ),
    );


    if (isNetwork) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }

    if (isLocal) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(imageUrl),
          width: 72,
          height: 72,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      );
    }

    return placeholder;
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.amber.shade800;

    Widget cardChild = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(context, accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Text(
                      'THÔNG BÁO',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  event.title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LucideIcons.user,
                        size: 12, color: context.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.organizer ?? 'Ban Quản Trị',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(LucideIcons.calendar,
                        size: 12, color: context.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: cardChild,
    );
  }
}
