import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../auth/auth.dart';
import '../../../../events/events.dart';
import '../../../admin.dart';
import '../../widgets/events/event_filter_bar.dart';
import '../../widgets/events/event_item_card.dart';
import '../../widgets/events/announcement_item_card.dart';

class EventsListPage extends StatefulWidget {
  final int familyId;
  final bool isActive;

  const EventsListPage({
    super.key,
    required this.familyId,
    this.isActive = false,
  });

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'all'; // all, event, announcement
  String _selectedSort = 'newest'; // newest, oldest

  static const int _maxPreviewItemsPerSection = 3;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    if (widget.isActive) {
      _updateFAB();
    }
  }

  @override
  void didUpdateWidget(covariant EventsListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _updateFAB();
    }
  }

  void _loadEvents() {
    context.read<EventsBloc>().add(LoadEventsEvent(familyId: widget.familyId));
  }

  void _updateFAB() {
    final authState = context.read<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
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
              _loadEvents();
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
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserMainNavigationPage.fabNotifier.value?.label == 'event_add_fab') {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
    super.dispose();
  }

  Future<void> _navigateToDetail(EventEntity event) async {
    final result = await Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: AdminEventDetailPage(
          familyId: widget.familyId,
          event: event,
        ),
      ),
    );
    if (result == true) _loadEvents();
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
            child: Text(l10n.deleteLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent(EventEntity event) async {
    final eventsBloc = context.read<EventsBloc>();
    final confirm = await _showConfirmDeleteDialog(event);
    if (confirm == true && mounted) {
      eventsBloc.add(
        DeleteEventEvent(
          id: event.id,
          familyId: widget.familyId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'EDITOR' ||
            authState.user.role == 'CREATOR');

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.eventsListTitle,
      ),
      body: AppBackgroundBody(
        child: BlocConsumer<EventsBloc, EventsState>(
          listener: (context, state) {
            if (state is EventsSubmitSuccess) {
              AppSnackBar.success(context, state.message);
              _loadEvents();
            } else if (state is EventsError) {
              AppSnackBar.error(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is EventsLoading ||
                state is EventsInitial) {
              return const EventsListSkeleton();
            }

            if (state is EventsSubmitting) {
              return const Center(child: AppLoading(size: 80));
            }

            List<EventEntity> allEvents = [];
            if (state is EventsLoaded) {
              allEvents = state.events;
            }

            final counts = {
              'all': allEvents.length,
              'event': allEvents
                  .where((e) => e.type == 'event' || e.type == 'article')
                  .length,
              'announcement':
                  allEvents.where((e) => e.type == 'announcement').length,
            };

            // Apply search & filter
            var filteredEvents = allEvents;
            final query = _searchController.text.trim().toLowerCase();
            if (query.isNotEmpty) {
              filteredEvents = filteredEvents
                  .where((e) => e.title.toLowerCase().contains(query))
                  .toList();
            }

            if (_selectedType == 'event') {
              filteredEvents = filteredEvents
                  .where((e) => e.type == 'event' || e.type == 'article')
                  .toList();
            } else if (_selectedType == 'announcement') {
              filteredEvents = filteredEvents
                  .where((e) => e.type == 'announcement')
                  .toList();
            }

            if (_selectedSort == 'newest') {
              filteredEvents.sort((a, b) => b.eventDate.compareTo(a.eventDate));
            } else {
              filteredEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
            }

            final eventsList = filteredEvents
                .where((e) => e.type == 'event' || e.type == 'article')
                .toList();
            final announcementsList =
                filteredEvents.where((e) => e.type == 'announcement').toList();

            final displayEvents = _selectedType == 'all'
                ? eventsList.take(_maxPreviewItemsPerSection).toList()
                : eventsList;
            final displayAnnouncements = _selectedType == 'all'
                ? announcementsList.take(_maxPreviewItemsPerSection).toList()
                : announcementsList;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.topCenter,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
              child: SingleChildScrollView(
                key: ValueKey('$_selectedType-$_selectedSort-${_searchController.text}'),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Section 1: Scrollable Filter Chips ──
                    EventFilterBar(
                      selectedType: _selectedType,
                      onSelectType: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                      counts: counts,
                    ),

                    // ── Section 2: Search & Sort Bar ──
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppSearchBar(
                              controller: _searchController,
                              hintText: l10n.eventSearchHint,
                              onChanged: (_) => setState(() {}),
                              trailing: [
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: Icon(
                                      LucideIcons.listFilter,
                                      size: 20,
                                      color: context.textSecondary,
                                    ),
                                    offset: const Offset(0, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    color: context.surface,
                                    elevation: 4,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'clear_all',
                                        height: 38,
                                        child: Row(
                                          children: [
                                            Icon(LucideIcons.filterX,
                                                color: context.textPrimary, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Bỏ chọn tất cả',
                                              style: GoogleFonts.beVietnamPro(
                                                  fontSize: 13,
                                                  color: context.textPrimary),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedSort = 'newest';
                                          });
                                        },
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<String>(
                                        enabled: false,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: StatefulBuilder(
                                          builder: (context, setPopupState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Sắp xếp',
                                                    style: GoogleFonts.beVietnamPro(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: context.textPrimary)),
                                                const SizedBox(height: 8),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: CupertinoSlidingSegmentedControl<String>(
                                                    backgroundColor: context.isDarkMode
                                                        ? Colors.grey.shade900
                                                        : Colors.grey.shade200,
                                                    thumbColor: context.isDarkMode
                                                        ? Colors.grey.shade700
                                                        : Colors.white,
                                                    groupValue: _selectedSort,
                                                    children: {
                                                      'newest': Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        child: Text(
                                                          'Mới nhất',
                                                          textAlign: TextAlign.center,
                                                          style: GoogleFonts.beVietnamPro(
                                                            fontSize: 12,
                                                            color: context.textPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                      'oldest': Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        child: Text(
                                                          'Cũ nhất',
                                                          textAlign: TextAlign.center,
                                                          style: GoogleFonts.beVietnamPro(
                                                            fontSize: 12,
                                                            color: context.textPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                    },
                                                    onValueChanged: (value) {
                                                      if (value != null) {
                                                        setState(() => _selectedSort = value);
                                                        setPopupState(() {});
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
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

                    const SizedBox(height: 12),

                    // Empty state when filtered output is empty
                    if (filteredEvents.isEmpty)
                      AppEmptyState(
                        message: l10n.eventNoResults,
                        icon: LucideIcons.fileX,
                        iconSize: 42,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 40),
                      ),

                    // ── Group 1: SỰ KIỆN ──
                    if ((_selectedType == 'all' || _selectedType == 'event') &&
                        eventsList.isNotEmpty) ...[
                      _buildSectionHeader(
                        l10n.clanEventsSection,
                        eventsList.length,
                        onViewAll: (_selectedType == 'all' &&
                                eventsList.length > _maxPreviewItemsPerSection)
                            ? () => setState(() => _selectedType = 'event')
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: displayEvents.map((event) {
                            final cardWidget = EventItemCard(
                              event: event,
                              canEdit: canEdit,
                              onTap: () => _navigateToDetail(event),
                              onDelete: () => _deleteEvent(event),
                            );
                            if (canEdit) {
                              return SwipeableCard(
                                key: ValueKey(event.id),
                                onDelete: () => _deleteEvent(event),
                                onTap: () => _navigateToDetail(event),
                                deleteLabel: l10n.deleteLabel,
                                child: cardWidget,
                              );
                            }
                            return cardWidget;
                          }).toList(),
                        ),
                      ),
                    ],

                    // ── Group 2: THÔNG BÁO ──
                    if ((_selectedType == 'all' ||
                            _selectedType == 'announcement') &&
                        announcementsList.isNotEmpty) ...[
                      _buildSectionHeader(
                        l10n.clanAnnouncementsSection,
                        announcementsList.length,
                        onViewAll: (_selectedType == 'all' &&
                                announcementsList.length >
                                    _maxPreviewItemsPerSection)
                            ? () =>
                                setState(() => _selectedType = 'announcement')
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: displayAnnouncements.map((event) {
                            final cardWidget = AnnouncementItemCard(
                              event: event,
                              canEdit: canEdit,
                              onTap: () => _navigateToDetail(event),
                              onDelete: () => _deleteEvent(event),
                            );
                            if (canEdit) {
                              return SwipeableCard(
                                key: ValueKey(event.id),
                                onDelete: () => _deleteEvent(event),
                                onTap: () => _navigateToDetail(event),
                                deleteLabel: l10n.deleteLabel,
                                child: cardWidget,
                              );
                            }
                            return cardWidget;
                          }).toList(),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count,
      {VoidCallback? onViewAll}) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: context.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: context.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.beVietnamPro(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: context.textSecondary,
              ),
            ),
          ),
          const Spacer(),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.viewAllLabel,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    LucideIcons.chevronRight,
                    size: 14,
                    color: context.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
