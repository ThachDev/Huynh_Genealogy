// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vnlunar/vnlunar.dart';

import '../../../../core/data/repository/notification_read_controller.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../features/auth/auth.dart';
import '../../../../features/family_tree/family_tree.dart';
import '../../../events/events.dart';
import '../../../admin/admin.dart';
import '../models/upcoming_anniversary.dart';
import '../widgets/anniversary_card.dart';
import '../widgets/user_event_card.dart';
import '../widgets/user_notifications_widget.dart';
import 'user_anniversary_list_page.dart';
import 'user_event_list_page.dart';

class UserEventsPage extends StatefulWidget {
  final int familyId;
  final bool isActive;
  final bool isAdminMode;

  const UserEventsPage({
    super.key,
    required this.familyId,
    this.isActive = false,
    this.isAdminMode = false,
  });

  @override
  State<UserEventsPage> createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage> {
  final ScrollController _scrollController = ScrollController();
  int _eventLimit = 5;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadReadState();
    _scrollController.addListener(_onScroll);
    if (widget.isActive) {
      _updateFAB();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserMainNavigationPage.fabNotifier.value?.label == 'event_add_fab') {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _eventLimit += 5;
      });
    }
  }

  Future<void> _loadReadState() async {
    await NotificationReadController.instance.ensureLoaded(widget.familyId);
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant UserEventsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _updateFAB();
    }
  }

  void _loadData() {
    context.read<EventsBloc>().add(LoadEventsEvent(familyId: widget.familyId));

    final treeState = context.read<FamilyTreeBloc>().state;
    if (treeState is! FamilyTreeLoaded && treeState is! FamilyTreeLoading) {
      context
          .read<FamilyTreeBloc>()
          .add(FamilyTreeLoadEvent(familyId: widget.familyId));
    }
  }

  void _updateFAB() {
    final authState = context.read<AuthBloc>().state;
    final canEdit = widget.isAdminMode &&
        authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');

    if (canEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UserMainNavigationPage.fabNotifier.value = FABConfig(
          icon: LucideIcons.calendar,
          label: 'event_add_fab',
          onTap: () async {
            final result = await Navigator.push(
              context,
              SereneFadeSlidePageRoute(
                page: AdminEventCreatePage(familyId: widget.familyId),
              ),
            );
            if (result == true) {
              _loadData();
            }
          },
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UserMainNavigationPage.fabNotifier.value = null;
      });
    }
  }

  List<UpcomingAnniversary> _calculateDeathAnniversaries(
      List<MemberEntity> members) {
    final List<UpcomingAnniversary> anniversaries = [];
    final today = DateTime.now();
    final todayOnlyDate = DateTime(today.year, today.month, today.day);

    for (final member in members) {
      if (member.isAlive) continue;

      int? lunarDay;
      int? lunarMonth;

      if (member.lunarDeathDate != null && member.lunarDeathDate!.isNotEmpty) {
        final match =
            RegExp(r'(\d+)\/(\d+)').firstMatch(member.lunarDeathDate!);
        if (match != null) {
          lunarDay = int.tryParse(match.group(1) ?? '');
          lunarMonth = int.tryParse(match.group(2) ?? '');
        }
      }

      if (lunarDay == null || lunarMonth == null) {
        if (member.dateOfDeath != null && member.dateOfDeath!.isNotEmpty) {
          try {
            final parts = member.dateOfDeath!.split('-');
            if (parts.length == 3) {
              final year = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              final day = int.tryParse(parts[2]);
              if (year != null && month != null && day != null) {
                final dt = DateTime(year, month, day);
                final lunar = Lunar(createdFromSolar: true, date: dt);
                lunarDay = lunar.day;
                lunarMonth = lunar.month;
              }
            }
          } catch (_) {}
        }
      }

      if (lunarDay != null && lunarMonth != null) {
        try {
          final todayLunar = Lunar(createdFromSolar: true, date: today);
          final currentLunarYear = todayLunar.year;

          // Convert current lunar year anniversary to solar date
          final listSolar = convertLunar2Solar(
              lunarDay, lunarMonth, currentLunarYear, false, 7);
          var solarAnniversary =
              DateTime(listSolar[2], listSolar[1], listSolar[0]);

          if (solarAnniversary.isBefore(todayOnlyDate)) {
            final nextListSolar = convertLunar2Solar(
                lunarDay, lunarMonth, currentLunarYear + 1, false, 7);
            solarAnniversary =
                DateTime(nextListSolar[2], nextListSolar[1], nextListSolar[0]);
          }

          final days = solarAnniversary.difference(todayOnlyDate).inDays;
          final solarLabel =
              '${solarAnniversary.day.toString().padLeft(2, '0')}/${solarAnniversary.month.toString().padLeft(2, '0')}';
          final lunarLabel =
              '${lunarDay.toString().padLeft(2, '0')}/${lunarMonth.toString().padLeft(2, '0')} ÂL';

          anniversaries.add(UpcomingAnniversary(
            member: member,
            title: member.fullName,
            solarDateLabel: solarLabel,
            lunarDateLabel: lunarLabel,
            daysRemaining: days,
            isBirthday: false,
          ));
        } catch (_) {}
      }
    }

    anniversaries.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return anniversaries;
  }

  List<UpcomingAnniversary> _calculateBirthdays(List<MemberEntity> members) {
    final List<UpcomingAnniversary> birthdays = [];
    final today = DateTime.now();
    final todayOnlyDate = DateTime(today.year, today.month, today.day);

    for (final member in members) {
      if (!member.isAlive) continue;
      if (member.dateOfBirth == null || member.dateOfBirth!.isEmpty) continue;

      try {
        final parts = member.dateOfBirth!.split('-');
        if (parts.length == 3) {
          final birthMonth = int.tryParse(parts[1]);
          final birthDay = int.tryParse(parts[2]);

          if (birthMonth != null && birthDay != null) {
            var birthdayThisYear = DateTime(today.year, birthMonth, birthDay);
            if (birthdayThisYear.isBefore(todayOnlyDate)) {
              birthdayThisYear = DateTime(today.year + 1, birthMonth, birthDay);
            }

            final days = birthdayThisYear.difference(todayOnlyDate).inDays;
            final solarLabel =
                '${birthDay.toString().padLeft(2, '0')}/${birthMonth.toString().padLeft(2, '0')}';

            birthdays.add(UpcomingAnniversary(
              member: member,
              title: member.fullName,
              solarDateLabel: solarLabel,
              daysRemaining: days,
              isBirthday: true,
            ));
          }
        }
      } catch (_) {}
    }

    birthdays.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return birthdays;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final canEdit = widget.isAdminMode &&
        authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');

    return BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
      builder: (context, treeState) {
        return BlocBuilder<EventsBloc, EventsState>(
          builder: (context, eventsState) {
            List<EventEntity> allEvents = [];
            if (eventsState is EventsLoaded) {
              allEvents = eventsState.events;
            }

            final announcements = allEvents.where((e) {
              final t = e.type.toLowerCase();
              return t == 'announcement' ||
                  t == 'notification' ||
                  t == 'thông báo';
            }).toList();

            final displayEvents = allEvents.where((e) {
              final t = e.type.toLowerCase();
              return t != 'announcement' &&
                  t != 'notification' &&
                  t != 'thông báo';
            }).toList();

            final unreadAnnouncements = announcements
                .where((e) => !NotificationReadController.instance
                    .isRead(e.id.toString()))
                .toList();

            return Scaffold(
              appBar: AppAppBar(
                title: l10n.eventsListTitle,
                actions: [
                  IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(LucideIcons.bell,
                            color: context.textPrimary, size: 22),
                        if (unreadAnnouncements.isNotEmpty)
                          Positioned(
                            top: -8,
                            right: -6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${unreadAnnouncements.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        SereneFadeSlidePageRoute(
                          page: UserNotificationsPage(
                            familyId: widget.familyId,
                            announcements: announcements,
                            isAdminMode: widget.isAdminMode,
                          ),
                        ),
                      );
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    tooltip: l10n.eventTypeAnnouncement,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: AppBackgroundBody(
                child: Builder(
                  builder: (context) {
                    if (eventsState is EventsLoading ||
                        eventsState is EventsInitial ||
                        eventsState is EventsSubmitting ||
                        treeState is FamilyTreeLoading) {
                      return const UserEventsSkeleton();
                    }

                    List<MemberEntity> members = [];
                    if (treeState is FamilyTreeLoaded) {
                      members = treeState.members;
                    }

                    final deathAnniversaries =
                        _calculateDeathAnniversaries(members);
                    final birthdays = _calculateBirthdays(members);

                    return SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Section 1: Ngày Giỗ Dòng Họ ──
                          if (deathAnniversaries.isNotEmpty &&
                              !widget.isAdminMode) ...[
                            AppSectionTitle(
                              title: l10n.deathAnniversariesSectionTitle,
                              trailing: _buildTrailingSeeAll(
                                onTap: () => _openAnniversaryList(
                                  l10n.deathAnniversariesSectionTitle,
                                  deathAnniversaries,
                                ),
                              ),
                            ),
                            _buildAnniversaryList(deathAnniversaries),
                          ],

                          // ── Section 2: Sinh Nhật Dòng Họ ──
                          if (birthdays.isNotEmpty && !widget.isAdminMode) ...[
                            AppSectionTitle(
                              title: l10n.birthdaysSectionTitle,
                              trailing: _buildTrailingSeeAll(
                                onTap: () => _openAnniversaryList(
                                  l10n.birthdaysSectionTitle,
                                  birthdays,
                                  isBirthday: true,
                                ),
                              ),
                            ),
                            _buildAnniversaryList(birthdays),
                          ],

                          // ── Section 3: Sự Kiện ──
                          AppSectionTitle(
                            title: l10n.eventsListTitle,
                            trailing: _buildTrailingSeeAll(
                              onTap: () => _openEventList(displayEvents),
                            ),
                          ),

                          if (displayEvents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 48, horizontal: 16),
                              child: AppEmptyState(
                                icon: LucideIcons.calendarDays,
                                message: l10n.noEventsMessage,
                              ),
                            )
                          else
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayEvents.length > _eventLimit
                                    ? _eventLimit
                                    : displayEvents.length,
                                itemBuilder: (context, index) {
                                  final event = displayEvents[index];
                                  return _buildEventCard(event, canEdit);
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openAnniversaryList(
    String title,
    List<UpcomingAnniversary> list, {
    bool isBirthday = false,
  }) {
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: UserAnniversaryListPage(
          title: title,
          anniversaries: list,
          isBirthday: isBirthday,
        ),
      ),
    );
  }

  void _openEventList(List<EventEntity> events) {
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: UserEventListPage(
          familyId: widget.familyId,
          isAdminMode: widget.isAdminMode,
          events: events,
        ),
      ),
    );
  }

  Widget _buildTrailingSeeAll({VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          AppLocalizations.of(context)!.seeMoreLabel,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.primary,
          ),
        ),
      ),
    );
  }

  /// Danh sách cuộn ngang dùng chung cho cả Ngày Giỗ và Sinh Nhật.
  Widget _buildAnniversaryList(List<UpcomingAnniversary> list) {
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 124,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            clipBehavior: Clip.none,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final data = list[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < list.length - 1 ? 16 : 0,
                ),
                child: AnniversaryCard(data: data),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> openDetail() async {
      final result = await Navigator.push(
        context,
        SereneFadeSlidePageRoute(
          page: AdminEventDetailPage(
            familyId: widget.familyId,
            event: event,
            isUserView: !widget.isAdminMode,
          ),
        ),
      );
      if (result == true && mounted) {
        _loadData();
      }
    }

    if (canEdit) {
      return SwipeableCard(
        deleteLabel: l10n.deleteLabel,
        onDelete: () async {
          final confirm = await _showConfirmDeleteDialog(event);
          if (confirm == true && mounted) {
            context.read<EventsBloc>().add(
                  DeleteEventEvent(id: event.id, familyId: widget.familyId),
                );
          }
        },
        onTap: openDetail,
        child: UserEventCard(
          familyId: widget.familyId,
          isAdminMode: widget.isAdminMode,
          event: event,
          tappable: false,
          heroTag: 'event_image_${event.id}',
          onChanged: _loadData,
        ),
      );
    }

    return UserEventCard(
      familyId: widget.familyId,
      isAdminMode: widget.isAdminMode,
      event: event,
      heroTag: 'event_image_${event.id}',
      onChanged: _loadData,
    );
  }

  Future<bool?> _showConfirmDeleteDialog(EventEntity event) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.surface,
        title: Text(l10n.deleteEventTitle,
            style: GoogleFonts.beVietnamPro(color: context.textPrimary)),
        content: Text(l10n.deleteEventConfirm(event.title),
            style: GoogleFonts.inter(color: context.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelLabel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteLabel,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
