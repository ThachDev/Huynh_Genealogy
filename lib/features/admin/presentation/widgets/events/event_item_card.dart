import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../events/events.dart';
import 'event_calendar_widget.dart';
import 'swipeable_card.dart';

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

  String _getEventStatus() {
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

  Widget _buildStatusTag(String status) {
    String statusText = 'Đã kết thúc';
    Color statusColor = Colors.grey;

    if (status == 'active') {
      statusText = 'Đang diễn ra';
      statusColor = AppColors.success;
    } else if (status == 'upcoming') {
      statusText = 'Sắp diễn ra';
      statusColor = Colors.blue;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          statusText,
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerImage(BuildContext context) {
    final imageUrl = event.imageUrl;
    final isNetwork = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocal =
        imageUrl != null && !isNetwork && File(imageUrl).existsSync();

    if (isNetwork) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.network(
          imageUrl,
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      );
    }

    if (isLocal) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Image.file(
          File(imageUrl),
          height: 120,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status = _getEventStatus();
    final hasImage = event.imageUrl != null && event.imageUrl!.isNotEmpty;

    Widget cardChild = Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasImage) _buildBannerImage(context),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Calendar Badge Component
                SizedBox(
                  width: 72,
                  height: 72,
                  child: EventCalendarWidget(
                    eventDate: event.eventDate,
                    badgeColor: status == 'active'
                        ? AppColors.success
                        : (status == 'upcoming'
                            ? Colors.blue
                            : AppColors.error),
                    l10n: l10n,
                  ),
                ),
                const SizedBox(width: 14),

                // Event info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildStatusTag(status),
                          const Spacer(),
                          if (event.isLunar)
                            Text(
                              'LỊCH ÂM',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: context.accent,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.title,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (event.location != null &&
                          event.location!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(LucideIcons.mapPin,
                                size: 13, color: context.textSecondary),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                event.location!,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
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
            ),
          ),
        ],
      ),
    );

    if (canEdit) {
      return SwipeableCard(
        deleteLabel: l10n.deleteLabel,
        onDelete: onDelete,
        onTap: onTap,
        child: GestureDetector(
          onTap: onTap,
          child: cardChild,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: cardChild,
    );
  }
}
