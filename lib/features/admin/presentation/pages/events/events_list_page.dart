import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../features/auth/auth.dart';
import '../../../admin.dart';
import '../../../../../core/domain/entity/event_entity.dart';

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
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');

    if (canEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UserMainNavigationPage.fabNotifier.value = FABConfig(
          icon: LucideIcons.calendar,
          label: 'event_add_fab',
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminEventCreatePage(familyId: widget.familyId),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserMainNavigationPage.fabNotifier.value?.label == 'event_add_fab') {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthBloc>().state;
    final canEdit = authState is Authenticated &&
        (authState.user.role == 'OWNER' ||
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: l10n.eventsListTitle,
      ),
      floatingActionButton: null,
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is EventsSubmitSuccess) {
            AppSnackBar.success(context, state.message);
            _loadEvents();
          } else if (state is EventsError) {
            AppSnackBar.error(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is EventsLoading || state is EventsSubmitting) {
            return const Center(child: AppLoading(size: 80));
          }

          if (state is EventsLoaded) {
            final events = state.events;
            if (events.isEmpty) {
              return AppEmptyState(
                icon: LucideIcons.calendarDays,
                message: l10n.noEventsMessage,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(event, canEdit);
              },
            );
          }

          return Center(child: Text(l10n.errorOccurred));
        },
      ),
    );
  }

  Widget _buildEventCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;

    // Category badges configuration
    Color badgeColor = context.primary;
    String badgeLabel = 'Sự kiện';
    IconData badgeIcon = LucideIcons.calendar;

    switch (event.type) {
      case 'article':
        badgeColor = context.primary;
        badgeLabel = 'Tin tức';
        badgeIcon = LucideIcons.bookOpen;
        break;
      case 'announcement':
        badgeColor = context.primary;
        badgeLabel = 'Thông báo';
        badgeIcon = LucideIcons.megaphone;
        break;
      case 'event':
      default:
        badgeColor = context.primary;
        badgeLabel = 'Sự kiện';
        badgeIcon = LucideIcons.calendar;
        break;
    }

    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Date Badge (Calendar style with flip animation) - Flex 2, full height
                Expanded(
                  flex: 2,
                  child: EventCalendarWidget(
                    eventDate: event.eventDate,
                    badgeColor: badgeColor,
                    l10n: l10n,
                  ),
                ),
                const SizedBox(width: 16),

                // Middle details - Flex 5
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Category Tag in Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(badgeIcon, size: 10, color: badgeColor),
                                const SizedBox(width: 4),
                                Text(
                                  badgeLabel.toUpperCase(),
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: badgeColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Short Description
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

                      // Metadata (Location & Organizer)
                      const SizedBox(height: 8),
                      if (event.location != null &&
                          event.location!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(LucideIcons.mapPin,
                                size: 12, color: context.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location!,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: context.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (event.organizer != null &&
                          event.organizer!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(LucideIcons.user,
                                size: 12, color: context.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.organizer!,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
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

                // Right Thumbnail Image (if exists)
                if (hasImage) ...[
                  const SizedBox(width: 12),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: context.textSecondary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: isNetworkImage
                          ? Image.network(
                              imageUrl,
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(LucideIcons.image, size: 20),
                              ),
                            )
                          : Image.file(
                              File(imageUrl),
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(LucideIcons.image, size: 20),
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

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
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminEventDetailPage(
                familyId: widget.familyId,
                event: event,
              ),
            ),
          );
          if (result == true) {
            _loadEvents();
          }
        },
        child: cardContent,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: cardContent,
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


