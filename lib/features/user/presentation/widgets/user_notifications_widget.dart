import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../admin/presentation/pages/events/admin_event_detail_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../events/events.dart';
import '../../../family_tree/domain/entities/member_entity.dart';
import '../../../family_tree/presentation/bloc/family_tree_bloc.dart';
import '../../domain/entities/wish_entity.dart';
import '../../domain/repository/wish_repository.dart';
import '../models/upcoming_anniversary.dart';
import '../pages/wish_wall_page.dart';

enum NotificationFeedType {
  announcement,
  event,
  birthdayWish,
  generalWish,
}

class NotificationFeedItem {
  NotificationFeedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.senderName,
    required this.senderAvatar,
    required this.dateTime,
    required this.isRead,
    this.rawEvent,
    this.rawWish,
  });

  final String id;
  final NotificationFeedType type;
  final String title;
  final String content;
  final String? senderName;
  final String? senderAvatar;
  final DateTime dateTime;
  final bool isRead;
  final EventEntity? rawEvent;
  final WishEntity? rawWish;
}

/// Trang Thông Báo hợp nhất kiểu Facebook (Single Feed + Badge Icon trên Avatar).
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
  bool _isLoadingWishes = true;
  List<WishEntity> _myWishes = [];
  bool _filterOnlyUnread = false;

  @override
  void initState() {
    super.initState();
    _loadReadState();
    _loadWishes();
  }

  Future<void> _loadReadState() async {
    await NotificationReadController.instance.ensureLoaded(widget.familyId);
  }

  Future<void> _loadWishes() async {
    setState(() => _isLoadingWishes = true);
    try {
      final authState = context.read<AuthBloc>().state;
      int? memberId;
      if (authState is Authenticated) {
        memberId = authState.user.memberId;
      }
      final wishRepo = di.sl<WishRepository>();
      final result = await wishRepo.getMyWishes(memberId: memberId);
      result.fold(
        (_) {
          if (mounted) {
            setState(() {
              _myWishes = [];
              _isLoadingWishes = false;
            });
          }
        },
        (wishes) {
          if (mounted) {
            for (final w in wishes) {
              if (w.isRead) {
                NotificationReadController.instance.markRead('wish_${w.id}');
              }
            }
            setState(() {
              _myWishes = wishes;
              _isLoadingWishes = false;
            });
          }
        },
      );
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingWishes = false);
      }
    }
  }

  void _markAllAsRead(List<NotificationFeedItem> items) {
    final l10n = AppLocalizations.of(context);
    final eventIds =
        items.where((i) => i.rawEvent != null).map((i) => i.id).toList();
    final wishIds =
        items.where((i) => i.rawWish != null).map((i) => i.id).toList();

    if (eventIds.isNotEmpty) {
      NotificationReadController.instance.markAllRead(eventIds);
    }
    if (wishIds.isNotEmpty) {
      NotificationReadController.instance.markAllRead(wishIds);
    }
    AppSnackBar.success(context, l10n.markAllReadSuccess);
  }

  void _onItemTap(NotificationFeedItem item) {
    NotificationReadController.instance.markRead(item.id);

    // 1. Nhấn vào sự kiện / thông báo -> Mở thẳng trang Chi tiết Sự kiện
    if (item.rawEvent != null) {
      Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: AdminEventDetailPage(
            familyId: widget.familyId,
            event: item.rawEvent!,
            isUserView: !widget.isAdminMode,
          ),
        ),
      );
      return;
    }

    // 2. Nhấn vào thông báo lời chúc / sinh nhật -> Mở Tường Lời Chúc (Wish Wall)
    if (item.rawWish != null) {
      final wish = item.rawWish!;
      MemberEntity? targetMember;
      final treeState = context.read<FamilyTreeBloc>().state;
      if (treeState is FamilyTreeLoaded) {
        for (final m in treeState.members) {
          if (m.id == wish.memberId) {
            targetMember = m;
            break;
          }
        }
      }

      final l10n = AppLocalizations.of(context);
      if (targetMember == null) {
        final authState = context.read<AuthBloc>().state;
        final user = authState is Authenticated ? authState.user : null;
        targetMember = MemberEntity(
          id: wish.memberId,
          fullName: user?.fullName ?? l10n.meLabel,
          gender: Gender.unknown,
          avatarUrl: user?.avatarUrl,
          familyId: widget.familyId,
        );
      }

      final isBday = wish.eventType.toLowerCase().contains('birthday') ||
          wish.eventType.toLowerCase().contains('sinh nhật');

      final upcomingData = UpcomingAnniversary(
        member: targetMember,
        title: isBday ? l10n.birthdayTab : l10n.notifWishTitle,
        solarDateLabel:
            '${wish.createdAt.day.toString().padLeft(2, '0')}/${wish.createdAt.month.toString().padLeft(2, '0')}/${wish.createdAt.year}',
        daysRemaining: 0,
        isBirthday: isBday,
        targetDate: wish.createdAt,
      );

      Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: WishWallPage(
            data: upcomingData,
            wishRepository: di.sl<WishRepository>(),
          ),
        ),
      );
    }
  }

  String _formatTimeAgo(DateTime dt, AppLocalizations l10n) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return l10n.timeJustNow;
    if (diff.inMinutes < 60) return l10n.minutesAgoFormat(diff.inMinutes);
    if (diff.inHours < 24) return l10n.hoursAgoFormat(diff.inHours);
    if (diff.inDays < 7) return l10n.daysAgoFormat(diff.inDays);
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primaryColor = context.primary;

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
                  t == 'thông báo' ||
                  t == 'event';
            }).toList();
          }

          // Lọc các sự kiện chưa bị xóa/dismiss
          final activeEvents = allEvents
              .where((e) =>
                  !e.isDismissed &&
                  !NotificationReadController.instance
                      .isDismissed(e.id.toString()))
              .toList();

          // Xây dựng danh sách thông báo hợp nhất (Events + Wishes)
          final List<NotificationFeedItem> feedItems = [];

          for (final ev in activeEvents) {
            final isAnnounce = ev.type.toLowerCase() == 'announcement' ||
                ev.type.toLowerCase() == 'notification' ||
                ev.type.toLowerCase() == 'thông báo';
            DateTime dt;
            try {
              dt = DateTime.parse(ev.eventDate);
            } catch (_) {
              dt = DateTime.now();
            }
            final isRead =
                NotificationReadController.instance.isRead(ev.id.toString());

            feedItems.add(
              NotificationFeedItem(
                id: ev.id.toString(),
                type: isAnnounce
                    ? NotificationFeedType.announcement
                    : NotificationFeedType.event,
                title: ev.title,
                content: ev.description ?? ev.content ?? '',
                senderName:
                    ev.organizer ?? (isAnnounce ? l10n.adminBoardLabel : l10n.clanLabel),
                senderAvatar: null,
                dateTime: dt,
                isRead: isRead,
                rawEvent: ev,
              ),
            );
          }

          for (final wish in _myWishes) {
            final isWishDismissed = NotificationReadController.instance
                .isDismissed('wish_${wish.id}');
            if (isWishDismissed) continue;

            final isBday = wish.eventType.toLowerCase().contains('birthday') ||
                wish.eventType.toLowerCase().contains('sinh nhật');
            final isRead =
                NotificationReadController.instance.isRead('wish_${wish.id}');

            feedItems.add(
              NotificationFeedItem(
                id: 'wish_${wish.id}',
                type: isBday
                    ? NotificationFeedType.birthdayWish
                    : NotificationFeedType.generalWish,
                title: isBday ? l10n.birthdayWishTitle : l10n.newWishTitle,
                content: wish.content,
                senderName: wish.senderName ?? l10n.aMemberLabel,
                senderAvatar: wish.senderAvatar,
                dateTime: wish.createdAt,
                isRead: isRead,
                rawWish: wish,
              ),
            );
          }

          // Sắp xếp giảm dần theo thời gian
          feedItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));

          final displayedList = _filterOnlyUnread
              ? feedItems.where((i) => !i.isRead).toList()
              : feedItems;

          final unreadCount = feedItems.where((i) => !i.isRead).length;

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppAppBar(
              title: l10n.notificationsSectionTitle,
            ),
            body: AppBackgroundBody(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── Header Bar: Bộ lọc Facebook (Tất cả / Chưa đọc) + Đọc tất cả ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Bộ nút lọc kiểu Facebook (Pill Filters)
                        Row(
                          children: [
                            _buildFilterChip(
                              context: context,
                              label: l10n.allTab,
                              isSelected: !_filterOnlyUnread,
                              onTap: () =>
                                  setState(() => _filterOnlyUnread = false),
                            ),
                            const SizedBox(width: 8),
                            _buildFilterChip(
                              context: context,
                              label: l10n.unreadTab,
                              count: unreadCount > 0 ? unreadCount : null,
                              isSelected: _filterOnlyUnread,
                              onTap: () =>
                                  setState(() => _filterOnlyUnread = true),
                            ),
                          ],
                        ),

                        // Nút "Đọc tất cả"
                        if (unreadCount > 0)
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => _markAllAsRead(feedItems),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.checkCheck,
                                    size: 15,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.markAllReadAction,
                                    style: GoogleFonts.beVietnamPro(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Danh Sách Feed Thông Báo ──
                  Expanded(
                    child: _isLoadingWishes
                        ? const Center(child: CircularProgressIndicator())
                        : displayedList.isEmpty
                            ? Center(
                                child: AppEmptyState(
                                  icon: LucideIcons.bellOff,
                                  message: _filterOnlyUnread
                                      ? l10n.noUnreadNotifications
                                      : l10n.noNotificationsMessage,
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _loadWishes,
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  itemCount: displayedList.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final item = displayedList[index];
                                    return _buildNotificationCard(
                                        context, item);
                                  },
                                ),
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

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    int? count,
  }) {
    final primaryColor = context.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : context.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : context.accent.withValues(alpha: 0.15),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : context.textSecondary,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 0.5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : context.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? primaryColor : Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationFeedItem item,
  ) {
    final l10n = AppLocalizations.of(context);
    final isRead = item.isRead;

    return RepaintBoundary(
      child: Semantics(
        label: item.title,
        button: true,
        child: Container(
          decoration: BoxDecoration(
            color: isRead
                ? context.surface
                : context.surface.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isRead
                  ? context.accent.withValues(alpha: 0.15)
                  : context.accent.withValues(alpha: 0.08),
            ),
            boxShadow: isRead
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _onItemTap(item),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                child: Row(
                  children: [
                    // ── 1. Avatar kiểu Facebook với Badge Icon góc dưới phải ──
                    _buildFacebookAvatarWithBadge(context, item),

                    const SizedBox(width: 12),

                    // ── 2. Nội dung thông báo kiểu Facebook ──
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dòng mô tả hành động (Bold tên người gửi)
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 13,
                                color: context.textPrimary,
                                height: 1.35,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${item.senderName ?? l10n.aMemberLabel} ',
                                  style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.w700,
                                    color: isRead
                                        ? context.primary
                                        : context.primary
                                            .withValues(alpha: 0.8),
                                  ),
                                ),
                                TextSpan(
                                  text: _getFeedActionDescription(item, l10n),
                                  style: GoogleFonts.beVietnamPro(
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                    color: context.textPrimary
                                        .withValues(alpha: isRead ? 1.0 : 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Nội dung trích dẫn (nếu có)
                          if (item.content.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.content,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: context.textSecondary
                                    .withValues(alpha: isRead ? 0.9 : 0.75),
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          const SizedBox(height: 4),

                          // Thời gian tương đối
                          Text(
                            _formatTimeAgo(item.dateTime, l10n),
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isRead
                                  ? context.primary.withValues(alpha: 0.8)
                                  : context.textSecondary
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 6),

                    // ── 3. Nút Menu 3 chấm đồng bộ cho tất cả thông báo ──
                    _buildMoreMenu(context, item, l10n),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Avatar với icon tag thông báo góc dưới bên phải (kiểu Facebook - màu đồng bộ)
  Widget _buildFacebookAvatarWithBadge(
    BuildContext context,
    NotificationFeedItem item,
  ) {
    final primaryColor = context.primary;
    IconData badgeIcon;

    switch (item.type) {
      case NotificationFeedType.birthdayWish:
        badgeIcon = LucideIcons.cake;
        break;
      case NotificationFeedType.generalWish:
        badgeIcon = LucideIcons.heart;
        break;
      case NotificationFeedType.announcement:
        badgeIcon = LucideIcons.megaphone;
        break;
      case NotificationFeedType.event:
        badgeIcon = LucideIcons.calendar;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Avatar chính
        AppAvatar(
          fullName: item.senderName ?? 'U',
          avatarUrl: item.senderAvatar,
          radius: 22,
          fontSize: 16,
        ),

        // Tag Icon kiểu Facebook (Bottom Right - đồng bộ màu thương hiệu)
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.surface,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                badgeIcon,
                size: 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getFeedActionDescription(NotificationFeedItem item, AppLocalizations l10n) {
    switch (item.type) {
      case NotificationFeedType.birthdayWish:
        return l10n.sentBirthdayWishToYou;
      case NotificationFeedType.generalWish:
        return l10n.sentWishToYou;
      case NotificationFeedType.announcement:
        return l10n.postedAnAnnouncementFormat(item.title);
      case NotificationFeedType.event:
        return l10n.createdNewEventFormat(item.title);
    }
  }

  Widget _buildMoreMenu(
    BuildContext context,
    NotificationFeedItem item,
    AppLocalizations l10n,
  ) {
    return PopupMenuButton<String>(
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
          NotificationReadController.instance.markRead(item.id);
        } else if (value == 'mark_unread') {
          NotificationReadController.instance.markUnread(item.id);
        } else if (value == 'delete') {
          NotificationReadController.instance.dismiss(item.id);
          AppSnackBar.show(
            context,
            message: l10n.notificationDeletedMessage,
            type: SnackBarType.success,
          );
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          value: item.isRead ? 'mark_unread' : 'mark_read',
          height: 38,
          child: Row(
            children: [
              Icon(
                item.isRead ? LucideIcons.circleDot : LucideIcons.checkCircle,
                color: context.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                item.isRead ? l10n.markAsUnreadAction : l10n.markAsReadAction,
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
    );
  }
}
