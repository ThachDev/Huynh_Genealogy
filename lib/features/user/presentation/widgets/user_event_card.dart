import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../events/events.dart';
import '../../../admin/admin.dart';

/// Banner mặc định khi sự kiện không có ảnh.
class EventDefaultBanner extends StatelessWidget {
  const EventDefaultBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.appBarBg,
          image: DecorationImage(
            image: AssetImage(
              context.isDarkMode
                  ? 'assets/images/background_appbar_dark.png'
                  : 'assets/images/background_appbar_light.png',
            ),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            onError: (_, __) {},
          ),
        ),
        child: Center(
          child: Icon(
            LucideIcons.calendarDays,
            size: 40,
            color: context.accent.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}

/// Card hiển thị sự kiện. Tap vào sẽ mở trang chi tiết.
class UserEventCard extends StatelessWidget {
  final EventEntity event;
  final int familyId;
  final bool isAdminMode;

  /// Ghi đè hành vi tap. Mặc định mở trang chi tiết sự kiện.
  final VoidCallback? onTap;

  /// Callback được gọi sau khi trang chi tiết trả về true (đã sửa/xoá).
  final VoidCallback? onChanged;

  /// Bọc ngoài bằng GestureDetector hay không (false khi nằm trong SwipeableCard).
  final bool tappable;

  /// Null để bỏ Hero.
  final String? heroTag;

  const UserEventCard({
    super.key,
    required this.event,
    required this.familyId,
    this.isAdminMode = false,
    this.onTap,
    this.onChanged,
    this.tappable = true,
    this.heroTag = '',
  });

  Future<void> _openDetail(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminEventDetailPage(
          familyId: familyId,
          event: event,
          isUserView: !isAdminMode,
        ),
      ),
    );
    if (result == true) {
      onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final Color badgeColor = context.primary;
    final String badgeLabel = switch (event.type) {
      'article' => l10n.eventTypeArticle,
      'announcement' => l10n.eventTypeAnnouncement,
      _ => l10n.eventTypeEvent,
    };
    final IconData badgeIcon = switch (event.type) {
      'article' => LucideIcons.bookOpen,
      'announcement' => LucideIcons.megaphone,
      _ => LucideIcons.calendar,
    };

    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    Widget banner = hasImage
        ? AspectRatio(
            aspectRatio: 16 / 9,
            child: isNetworkImage
                ? AppNetworkImage(
                    url: imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_) => const EventDefaultBanner(),
                  )
                : Image.file(
                    File(imageUrl),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const EventDefaultBanner(),
                  ),
          )
        : const EventDefaultBanner();

    if (heroTag != null && heroTag!.isNotEmpty) {
      banner = Hero(
        tag: heroTag!,
        child: banner,
      );
    }

    Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RepaintBoundary(
        child: Semantics(
          label: l10n.eventDetailSemanticLabel(event.eventDate, event.title),
          button: true,
          child: Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: context.textSecondary.withValues(alpha: 0.2),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  banner,

                  // Card Content
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: Tag & Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: badgeColor.withValues(alpha: 0.3),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    badgeIcon,
                                    size: 11,
                                    color: badgeColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    badgeLabel.toUpperCase(),
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: badgeColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.clock,
                                  size: 13,
                                  color: context.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.eventDate,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: context.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 2: Title
                        Text(
                          event.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        // Row 3: Description
                        if (event.description != null &&
                            event.description!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            event.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: context.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // Row 4: Author (left) & Location (right)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (event.organizer != null &&
                                event.organizer!.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.user,
                                      size: 13, color: context.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.organizer!,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: context.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            else
                              const SizedBox.shrink(),
                            if (event.location != null &&
                                event.location!.isNotEmpty)
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(LucideIcons.mapPin,
                                        size: 13, color: context.textSecondary),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        event.location!,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: context.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (!tappable) {
      return content;
    }

    final tap = onTap ?? () => _openDetail(context);
    return GestureDetector(
      onTap: tap,
      child: content,
    );
  }
}
