import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../admin/presentation/pages/events/admin_event_detail_page.dart';
import '../../../events/events.dart';

/// Trang Thông Báo dòng họ thiết kế theo UI/UX chuẩn hiện đại.
class UserNotificationsPage extends StatefulWidget {
  final int familyId;
  final List<EventEntity> announcements;
  final bool isAdminMode;

  /// Bộ lưu vết các thông báo đã đọc duy trì xuyên suốt ứng dụng.
  static final Set<String> globalReadIds = {};

  const UserNotificationsPage({
    super.key,
    required this.familyId,
    this.announcements = const [],
    this.isAdminMode = false,
  });

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  void _markAllAsRead(List<EventEntity> items) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      for (final e in items) {
        UserNotificationsPage.globalReadIds.add(e.id.toString());
      }
    });
    AppSnackBar.success(context, l10n.markAllReadSuccess);
  }

  void _onItemTap(EventEntity item) {
    setState(() {
      UserNotificationsPage.globalReadIds.add(item.id.toString());
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminEventDetailPage(
          familyId: widget.familyId,
          event: item,
          isUserView: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, eventsState) {
        List<EventEntity> allEvents = widget.announcements;
        if (allEvents.isEmpty && eventsState is EventsLoaded) {
          allEvents = eventsState.events.where((e) {
            final t = e.type.toLowerCase();
            return t == 'announcement' ||
                t == 'notification' ||
                t == 'thông báo';
          }).toList();
        }

        final displayList = allEvents;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppAppBar(
            title: l10n.eventTypeAnnouncement,
            automaticallyImplyLeading: true,
          ),
          body: AppBackgroundBody(
            child: Column(
              children: [
                const SizedBox(height: 12),

                // ── Row 1: Section Title + "Đọc tất cả" ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.importantLabel,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: displayList.isNotEmpty
                            ? () => _markAllAsRead(displayList)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.checkCheck,
                                size: 16,
                                color: context.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.markAllReadAction,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: context.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Row 2: Notification Items List ──
                Expanded(
                  child: displayList.isEmpty
                      ? Center(
                          child: AppEmptyState(
                            icon: LucideIcons.bellOff,
                            message: l10n.noNotificationsMessage,
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          itemCount: displayList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = displayList[index];
                            final isRead = UserNotificationsPage.globalReadIds
                                .contains(item.id.toString());
                            return _buildNotificationCard(
                                context, item, isRead);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget cho từng Item Thông Báo
  Widget _buildNotificationCard(
      BuildContext context, EventEntity item, bool isRead) {
    final l10n = AppLocalizations.of(context)!;
    final String? organizer = item.organizer?.trim();
    final bool hasOrganizer = organizer != null && organizer.isNotEmpty;
    final String initialLetter =
        hasOrganizer ? organizer[0].toUpperCase() : 'U';

    return RepaintBoundary(
      child: Semantics(
        label: l10n.notificationDetailTitle(item.title),
        button: true,
        child: Container(
          decoration: BoxDecoration(
            color: isRead
                ? context.surface.withValues(alpha: 0.5)
                : context.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead
                  ? context.textSecondary.withValues(alpha: 0.08)
                  : context.primary.withValues(alpha: 0.25),
              width: isRead ? 1 : 1.2,
            ),
            boxShadow: isRead
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _onItemTap(item),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar người đăng bên trái (kèm chấm đỏ chưa đọc)
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: context.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: hasOrganizer
                                ? Text(
                                    initialLetter,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: context.primary,
                                    ),
                                  )
                                : Icon(
                                    LucideIcons.user,
                                    color: context.primary,
                                    size: 20,
                                  ),
                          ),
                        ),
                        if (!isRead)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: context.surface, width: 1.5),
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // Nội dung thông báo ở giữa
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hàng subtitle: Người đăng (nếu có) • Ngày đăng
                          Row(
                            children: [
                              if (hasOrganizer) ...[
                                Text(
                                  organizer,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isRead
                                        ? context.textSecondary
                                        : context.primary,
                                  ),
                                ),
                                Text(
                                  ' • ',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: context.textSecondary,
                                  ),
                                ),
                              ],
                              Text(
                                item.eventDate,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Tiêu đề thông báo (maxLines: 2)
                          Text(
                            item.title,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight:
                                  isRead ? FontWeight.w500 : FontWeight.bold,
                              color: isRead
                                  ? context.textPrimary.withValues(alpha: 0.75)
                                  : context.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          // Nội dung tóm tắt (maxLines: 2)
                          if (item.description != null &&
                              item.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.description!,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: isRead
                                    ? context.textSecondary
                                        .withValues(alpha: 0.8)
                                    : context.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Icon tùy chọn 3 chấm bên phải (Căn giữa - Center)
                    Center(
                      child: IconButton(
                        icon: Icon(
                          LucideIcons.moreHorizontal,
                          size: 20,
                          color: context.textSecondary,
                        ),
                        onPressed: () => _showItemMenu(context, item),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showItemMenu(BuildContext context, EventEntity item) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.checkCircle),
              title: Text(l10n.markAsReadAction),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  UserNotificationsPage.globalReadIds.add(item.id.toString());
                });
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.trash2, color: Colors.red),
              title: Text(l10n.deleteNotificationAction,
                  style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
