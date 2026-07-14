import 'dart:io';
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
                builder: (_) => AdminEventFormPage(familyId: widget.familyId),
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
        badgeColor = Colors.teal;
        badgeLabel = 'Tin tức / Bài viết';
        badgeIcon = LucideIcons.bookOpen;
        break;
      case 'announcement':
        badgeColor = Colors.orange.shade800;
        badgeLabel = 'Thông báo';
        badgeIcon = LucideIcons.megaphone;
        break;
      case 'anniversary':
        badgeColor = Colors.deepPurple;
        badgeLabel = 'Giỗ chạp / Kỷ niệm';
        badgeIcon = LucideIcons.heart;
        break;
      case 'event':
      default:
        badgeColor = context.primary;
        badgeLabel = 'Sự kiện';
        badgeIcon = LucideIcons.calendar;
        break;
    }

    final hasImage = event.imageUrl != null && File(event.imageUrl!).existsSync();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            if (hasImage)
              Image.file(
                File(event.imageUrl!),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Date Badge
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: badgeColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _getDay(event.eventDate),
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                            Text(
                              _getMonthYear(event.eventDate),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: badgeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (event.isLunar) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade800,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.lunarCalendar,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 8,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Middle details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          event.title,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),

                        // Short Description
                        if (event.description != null && event.description!.isNotEmpty) ...[
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

                        // Metadata (Organizer & Location)
                        const SizedBox(height: 8),
                        if (event.organizer != null && event.organizer!.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(LucideIcons.user, size: 12, color: context.textSecondary),
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
                          const SizedBox(height: 4),
                        ],
                        if (event.location != null && event.location!.isNotEmpty) ...[
                          Row(
                            children: [
                              Icon(LucideIcons.mapPin, size: 12, color: context.textSecondary),
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
                        ],
                      ],
                    ),
                  ),

                  // Actions menu button
                  if (canEdit) ...[
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(LucideIcons.moreVertical, color: context.textSecondary, size: 20),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminEventFormPage(
                                familyId: widget.familyId,
                                event: event,
                              ),
                            ),
                          );
                          if (result == true) {
                            _loadEvents();
                          }
                        } else if (value == 'delete') {
                          final confirm = await _showConfirmDeleteDialog(event);
                          if (confirm == true && mounted) {
                            context.read<EventsBloc>().add(
                                  DeleteEventEvent(
                                      id: event.id, familyId: widget.familyId),
                                );
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(LucideIcons.edit3, size: 16),
                              const SizedBox(width: 8),
                              Text(l10n.editLabel),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                l10n.deleteLabel,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDay(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return parts[2];
      }
    } catch (_) {}
    return '--';
  }

  String _getMonthYear(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return '${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return '';
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
