import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../events/events.dart';
import '../../../admin/admin.dart';
import '../../../../core/widgets/widgets.dart';

/// Card sự kiện kiểu compact — ảnh thumbnail bên trái, nội dung bên phải.
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
      SereneFadeSlidePageRoute(
        page: AdminEventDetailPage(
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

    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    // ── Thumbnail ──────────────────────────────────────────────
    Widget thumbnail = Container(
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

    if (hasImage) {
      Widget imgWidget = isNetworkImage
          ? AppNetworkImage(
              url: imageUrl,
              width: 84,
              height: 84,
              fit: BoxFit.cover,
              errorBuilder: (_) => thumbnail,
            )
          : Image.file(
              File(imageUrl),
              width: 84,
              height: 84,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => thumbnail,
            );
      thumbnail = ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imgWidget,
      );
    }

    if (heroTag != null && heroTag!.isNotEmpty) {
      thumbnail = Hero(tag: heroTag!, child: thumbnail);
    }

    // ── Card ──────────────────────────────────────────────────
    Widget content = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RepaintBoundary(
        child: Semantics(
          label: l10n.eventDetailSemanticLabel(event.eventDate, event.title),
          button: true,
          child: Container(
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: context.textSecondary.withValues(alpha: 0.15),
                width: 1,
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
                thumbnail,
                const SizedBox(width: 12),

                // ── Text content ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Row(
                        children: [
                          const Spacer(),
                          Icon(LucideIcons.clock3, size: 11, color: context.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            event.eventDate,
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
                      if (event.description != null && event.description!.isNotEmpty) ...[
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

                      const SizedBox(height: 8),

                      // Organizer + Location
                      Row(
                        children: [
                          if (event.organizer != null && event.organizer!.isNotEmpty) ...[
                            Icon(LucideIcons.user, size: 11, color: context.textSecondary),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                event.organizer!,
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
                          if (event.organizer != null &&
                              event.organizer!.isNotEmpty &&
                              event.location != null &&
                              event.location!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text('·', style: TextStyle(color: context.textSecondary, fontSize: 11)),
                            ),
                          if (event.location != null && event.location!.isNotEmpty) ...[
                            Icon(LucideIcons.mapPin, size: 11, color: context.textSecondary),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                event.location!,
                                style: GoogleFonts.inter(fontSize: 11, color: context.textSecondary),
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
        ),
      ),
    );

    if (!tappable) return content;

    final tap = onTap ?? () => _openDetail(context);
    return GestureDetector(onTap: tap, child: content);
  }
}
