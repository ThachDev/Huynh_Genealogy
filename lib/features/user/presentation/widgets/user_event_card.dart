import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../../events/events.dart';
import '../../../admin/admin.dart';
import '../../../../core/widgets/widgets.dart';

/// Card sự kiện phong cách Facebook / Bản tin Gia Tộc (Clan Feed).
/// Bao gồm:
/// - Header: Người tổ chức / Ban trị sự + Huy hiệu
/// - Banner Cover (tỉ lệ 16:9) sắc nét, hỗ trợ tag ngày âm/dương ở góc
/// - Nội dung: Tiêu đề to rõ, mô tả tóm tắt, địa điểm
/// - Footer: Nút xem chi tiết & tương tác
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

    final organizerName =
        (event.organizer != null && event.organizer!.trim().isNotEmpty)
            ? event.organizer!.trim()
            : l10n.adminBoard;

    final displayContent = (event.content != null &&
            event.content!.trim().isNotEmpty)
        ? event.content!.trim()
        : (event.description != null && event.description!.trim().isNotEmpty)
            ? event.description!.trim()
            : null;

    Widget bannerWidget = AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.primary.withValues(alpha: 0.08),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.calendarDays,
                size: 40,
                color: context.primary.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 6),
              Text(
                event.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );

    if (hasImage) {
      Widget image = isNetworkImage
          ? AppNetworkImage(
              url: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_) => bannerWidget,
            )
          : Image.file(
              File(imageUrl),
              fit: BoxFit.cover,
              width: double.infinity,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => bannerWidget,
            );

      bannerWidget = AspectRatio(
        aspectRatio: 16 / 9,
        child: image,
      );
    }

    if (heroTag != null && heroTag!.isNotEmpty) {
      bannerWidget = Hero(tag: heroTag!, child: bannerWidget);
    }

    Widget content = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Header Post (Tác giả/Ban trị sự + Tag loại sự kiện) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      LucideIcons.users,
                      size: 18,
                      color: context.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              organizerName,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            LucideIcons.badgeCheck,
                            size: 14,
                            color: context.accent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock3,
                            size: 11,
                            color: context.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.eventDate,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: context.textSecondary,
                            ),
                          ),
                          if (event.isLunar) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: context.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.lunarShortLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: context.accent,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    event.type.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: context.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── 2. Banner Cover 16:9 ──
          Stack(
            children: [
              bannerWidget,
              // Tag ngày đè nhẹ góc dưới nếu có ảnh
              Positioned(
                bottom: 10,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.calendar,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        event.eventDate +
                            (event.isLunar ? ' (${l10n.lunarShortLabel})' : ''),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── 3. Content Body ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Description
                if (displayContent != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    displayContent,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.textSecondary,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Location
                if (event.location != null &&
                    event.location!.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 14,
                        color: context.accent,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location!.trim(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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

          // ── 4. Action Footer ──
          const Divider(height: 1, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Icon(
                  LucideIcons.sparkles,
                  size: 14,
                  color: context.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.familyTreeTitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.textSecondary,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _openDetail(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.eventDetailTitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 14,
                          color: context.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!tappable) return content;

    final tap = onTap ?? () => _openDetail(context);
    return GestureDetector(onTap: tap, child: content);
  }
}
