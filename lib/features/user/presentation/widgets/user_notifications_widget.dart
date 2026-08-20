import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../events/events.dart';

/// Trang Thông Báo dòng họ thiết kế theo UI/UX chuẩn hiện đại.
class UserNotificationsPage extends StatefulWidget {

  const UserNotificationsPage({
    super.key,
    required this.familyId,
    this.announcements = const [],
    this.isAdminMode = false,
  });
  final int familyId;
  final List<EventEntity> announcements;
  final bool isAdminMode;

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  @override
  void initState() {
    super.initState();
    _loadReadState();
  }

  Future<void> _loadReadState() async {
    await NotificationReadController.instance.ensureLoaded(widget.familyId);
  }

  void _markAllAsRead(List<EventEntity> items) {
    final l10n = AppLocalizations.of(context);
    NotificationReadController.instance.markAllRead(
      items.map((e) => e.id.toString()).toList(),
    );
    AppSnackBar.success(context, l10n.markAllReadSuccess);
  }

  void _onItemTap(EventEntity item) {
    NotificationReadController.instance.markRead(item.id.toString());
    Navigator.pop(context);
    UserMainNavigationPage.tabIndexNotifier.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: NotificationReadController.instance,
      builder: (context, _) => BlocBuilder<EventsBloc, EventsState>(
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

          final displayList = allEvents
              .where((e) =>
                  !e.isDismissed &&
                  !NotificationReadController.instance.isDismissed(e.id.toString()))
              .toList();

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppAppBar(
              title: l10n.eventTypeAnnouncement,
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
                              final isRead = NotificationReadController.instance
                                  .isRead(item.id.toString());
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
      ),
    );
  }

  /// Widget cho từng Item Thông Báo
  Widget _buildNotificationCard(
      BuildContext context, EventEntity item, bool isRead) {
    final l10n = AppLocalizations.of(context);
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
                                color: context.error,
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

                    // Menu tùy chọn 3 chấm chuẩn hệ thống
                    Center(
                      child: PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: context.surface,
                        surfaceTintColor: Colors.transparent,
                        elevation: 4,
                        offset: const Offset(0, 30),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          LucideIcons.moreHorizontal,
                          size: 20,
                          color: context.textSecondary,
                        ),
                        onSelected: (value) {
                          if (value == 'mark_read') {
                            NotificationReadController.instance
                                .markRead(item.id.toString());
                          } else if (value == 'delete') {
                            NotificationReadController.instance
                                .dismiss(item.id.toString());
                            AppSnackBar.show(
                              context,
                              message: l10n.notificationDeletedMessage,
                              type: SnackBarType.success,
                            );
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem<String>(
                            value: 'mark_read',
                            height: 38,
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.checkCircle,
                                  color: context.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.markAsReadAction,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    color: context.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            height: 38,
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.trash2,
                                  color: context.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.deleteNotificationAction,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 13,
                                    color: context.textPrimary,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
