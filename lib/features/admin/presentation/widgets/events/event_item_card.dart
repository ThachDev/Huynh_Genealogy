import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../events/events.dart';
import 'event_calendar_widget.dart';

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

  Widget _buildStatusTag(String status, BuildContext context,
      {bool isOverBanner = false}) {
    String statusText = 'Đã kết thúc';
    Color statusColor = isOverBanner
        ? Colors.grey.shade300
        : context.textSecondary.withValues(alpha: 0.7);

    if (status == 'active') {
      statusText = 'Đang diễn ra';
      statusColor =
          isOverBanner ? Colors.greenAccent.shade400 : context.primary;
    } else if (status == 'upcoming') {
      statusText = 'Sắp diễn ra';
      statusColor =
          isOverBanner ? Colors.amberAccent.shade200 : Colors.amber.shade800;
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
            color: isOverBanner ? Colors.white : statusColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerImage(BuildContext context, String status) {
    final imageUrl = event.imageUrl;
    final isNetwork = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocal =
        imageUrl != null && !isNetwork && File(imageUrl).existsSync();

    Widget? imageWidget;
    if (isNetwork) {
      imageWidget = Image.network(
        imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    } else if (isLocal) {
      imageWidget = Image.file(
        File(imageUrl),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      );
    }

    if (imageWidget == null) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        child: ColoredBox(
          color: context.surface,
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageWidget,
              // Subtle Gradient Overlay for badge contrast
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
              // Top Left: Lunar Calendar Badge
              if (event.isLunar)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.accent.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      'LỊCH ÂM',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              // Top Right: Status Tag Badge
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: _buildStatusTag(status, context, isOverBanner: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          if (hasImage) _buildBannerImage(context, status),
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
                    isLunarDefault: event.isLunar,
                    l10n: l10n,
                  ),
                ),
                const SizedBox(width: 14),

                // Event info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!hasImage)
                        Row(
                          children: [
                            _buildStatusTag(status, context),
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
                      if (!hasImage) const SizedBox(height: 8),
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
                                size: 12, color: context.textSecondary),
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
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(LucideIcons.user,
                              size: 12, color: context.textSecondary),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              event.organizer ?? 'Ban Quản Trị',
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
                  ),
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
