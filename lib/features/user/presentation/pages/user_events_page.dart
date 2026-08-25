// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../features/auth/auth.dart';
import '../../../../features/family_tree/family_tree.dart';
import '../../../events/events.dart';
import '../../../admin/admin.dart';
import '../widgets/user_event_card.dart';

class UserEventsPage extends StatefulWidget {
  const UserEventsPage({
    super.key,
    required this.familyId,
    this.isActive = false,
    this.isAdminMode = false,
  });
  final int familyId;
  final bool isActive;
  final bool isAdminMode;

  @override
  State<UserEventsPage> createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              final isAnnounce = t == 'announcement' ||
                  t == 'notification' ||
                  t == 'thông báo';
              return isAnnounce &&
                  !e.isDismissed &&
                  !NotificationReadController.instance
                      .isDismissed(e.id.toString());
            }).toList();

            final displayEvents = allEvents.where((e) {
              final t = e.type.toLowerCase();
              return t != 'announcement' &&
                  t != 'notification' &&
                  t != 'thông báo';
            }).toList();

            return Scaffold(
              appBar: AppAppBar(
                title: l10n.eventsListTitle,
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

                    return SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _buildTabContent(
                        context,
                        l10n,
                        canEdit,
                        displayEvents,
                        announcements,
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

  // ────────────────────────────────────────────────────────────────
  //  Tab Content: Chỉ hiển thị Sự Kiện Dòng Tộc
  // ────────────────────────────────────────────────────────────────
  Widget _buildTabContent(
    BuildContext context,
    AppLocalizations l10n,
    bool canEdit,
    List<EventEntity> displayEvents,
    List<EventEntity> announcements,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Bảng Tin Sự Kiện Dòng Tộc (Clan Event Feed) ──
        AppSectionTitle(
          title: l10n.eventsListTitle,
        ),
        if (displayEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: AppEmptyState(
              icon: LucideIcons.calendarDays,
              message: l10n.noEventsMessage,
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
        const SizedBox(height: 24),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────
  //  Event Card (swipeable for admin)
  // ────────────────────────────────────────────────────────────────
  Widget _buildEventCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context);

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

  // ────────────────────────────────────────────────────────────────
  //  Helpers
  // ────────────────────────────────────────────────────────────────

  Future<bool?> _showConfirmDeleteDialog(EventEntity event) {
    final l10n = AppLocalizations.of(context);
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
            style: ElevatedButton.styleFrom(backgroundColor: context.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteLabel,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
