// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vnlunar/vnlunar.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../features/auth/auth.dart';
import '../../../../features/family_tree/family_tree.dart';
import '../../../../core/domain/entity/member_entity.dart';
import '../../../../core/domain/entity/event_entity.dart';
import '../../../admin/admin.dart';

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

class _UpcomingAnniversary {
  final MemberEntity member;
  final String title;
  final String solarDateLabel;
  final String? lunarDateLabel;
  final int daysRemaining;
  final bool isBirthday;

  _UpcomingAnniversary({
    required this.member,
    required this.title,
    required this.solarDateLabel,
    this.lunarDateLabel,
    required this.daysRemaining,
    required this.isBirthday,
  });
}

class _UserEventsPageState extends State<UserEventsPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.isActive) {
      _updateFAB();
    }
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
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserMainNavigationPage.fabNotifier.value?.label == 'event_add_fab') {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
    super.dispose();
  }

  List<_UpcomingAnniversary> _calculateDeathAnniversaries(
      List<MemberEntity> members) {
    final List<_UpcomingAnniversary> anniversaries = [];
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

          anniversaries.add(_UpcomingAnniversary(
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

  List<_UpcomingAnniversary> _calculateBirthdays(List<MemberEntity> members) {
    final List<_UpcomingAnniversary> birthdays = [];
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

            birthdays.add(_UpcomingAnniversary(
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
            authState.user.role == 'BRANCH_ADMIN' ||
            authState.user.role == 'EDITOR');

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.eventsListTitle,
      ),
      body: AppBackgroundBody(
        child: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
          builder: (context, treeState) {
            return BlocBuilder<EventsBloc, EventsState>(
              builder: (context, eventsState) {
                if (eventsState is EventsLoading ||
                    eventsState is EventsSubmitting ||
                    treeState is FamilyTreeLoading) {
                  return const Center(child: AppLoading(size: 80));
                }

                List<MemberEntity> members = [];
                if (treeState is FamilyTreeLoaded) {
                  members = treeState.members;
                }

                final deathAnniversaries =
                    _calculateDeathAnniversaries(members);
                final birthdays = _calculateBirthdays(members);

                List<EventEntity> allEvents = [];
                if (eventsState is EventsLoaded) {
                  allEvents = eventsState.events;
                }

                return SingleChildScrollView(
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
                          trailing: _buildTrailingSeeAll(),
                        ),
                        _buildAnniversaryList(deathAnniversaries),
                      ],

                      // ── Section 2: Sinh Nhật Dòng Họ ──
                      if (birthdays.isNotEmpty && !widget.isAdminMode) ...[
                        AppSectionTitle(
                          title: l10n.birthdaysSectionTitle,
                          trailing: _buildTrailingSeeAll(),
                        ),
                        _buildAnniversaryList(birthdays),
                      ],

                      // ── Section 3: Sự Kiện & Tin Tức ──
                      AppSectionTitle(
                        title: l10n.newsEventsSectionTitle,
                        trailing: _buildTrailingSeeAll(),
                      ),

                      if (allEvents.isEmpty)
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allEvents.length,
                            itemBuilder: (context, index) {
                              final event = allEvents[index];
                              return _buildEventCard(event, canEdit);
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrailingSeeAll() {
    return IconButton(
      onPressed: () {},
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Icon(
        LucideIcons.chevronRight,
        size: 18,
        color: context.textSecondary,
      ),
    );
  }

  /// Danh sách cuộn ngang dùng chung cho cả Ngày Giỗ và Sinh Nhật.
  Widget _buildAnniversaryList(List<_UpcomingAnniversary> list) {
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 115,
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

    final Color badgeColor = context.primary;
    final String badgeLabel = switch (event.type) {
      'article' => l10n.eventTypeArticle,
      'announcement' => l10n.eventTypeAnnouncement,
      _ => l10n.eventTypeEvent,
    };
    final IconData badgeIcon = switch (event.type) {
      'article' => LucideIcons.bookOpen,
      'announcement' => LucideIcons.megaphone,
      _ => LucideIcons.calendar,
    };

    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: EventCalendarWidget(
                  eventDate: event.eventDate,
                  badgeColor: badgeColor,
                  l10n: l10n,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    if (event.description != null &&
                        event.description!.isNotEmpty)
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
            _loadData();
          }
        },
        child: cardContent,
      );
    }

    return cardContent;
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

// ── CUSTOM REUSABLE WIDGETS ──

/// Card dùng chung cho cả Ngày Giỗ (isBirthday: false) và Sinh Nhật (isBirthday: true).
class AnniversaryCard extends StatelessWidget {
  final _UpcomingAnniversary data;

  const AnniversaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isBirthday = data.isBirthday;
    final icon = isBirthday ? LucideIcons.cake : LucideIcons.flame;

    return TraditionalOrnamentalCard(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ── Header: icon + tên + đời ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: context.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (data.member.generation != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context)!
                            .generationLabel(data.member.generation!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 8),
          // ── Footer: ngày + countdown ──
          Row(
            children: [
              Icon(LucideIcons.calendar, size: 20, color: context.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.solarDateLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                    ),
                    if (data.lunarDateLabel != null)
                      Text(
                        data.lunarDateLabel!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: context.textSecondary,
                            ),
                      ),
                  ],
                ),
              ),
              CountdownBadge(days: data.daysRemaining, isBirthday: isBirthday),
            ],
          ),
        ],
      ),
    );
  }
}

class CountdownBadge extends StatelessWidget {
  final int days;
  final bool isBirthday;

  const CountdownBadge({
    super.key,
    required this.days,
    required this.isBirthday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppLocalizations.of(context)!.eventCountdown(days),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.textOnPrimary,
            ),
      ),
    );
  }
}
