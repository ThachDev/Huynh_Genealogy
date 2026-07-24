import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/utils/lunar_date_helper.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../features/auth/auth.dart';
import '../../../../events/events.dart';
import '../../../admin.dart';

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
  String _selectedType = 'all'; // all, event, article, announcement
  final String _selectedStatus = 'all'; // all, active, upcoming, past
  String _selectedSort = 'newest'; // newest, oldest

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
    _searchController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (UserMainNavigationPage.fabNotifier.value?.label == 'event_add_fab') {
        UserMainNavigationPage.fabNotifier.value = null;
      }
    });
    super.dispose();
  }

  // ── Stat Card builder using TraditionalOrnamentalCard ──
  Widget _buildStatCard(String title, String count, IconData icon, Color color,
      {required String typeKey}) {
    final isSelected = _selectedType == typeKey;
    const activeColor = AppColors.error;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedType = isSelected ? 'all' : typeKey;
        }),
        child: TraditionalOrnamentalCard(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          borderColor:
              isSelected ? activeColor : context.accent.withValues(alpha: 0.4),
          child: Column(
            children: [
              Icon(icon,
                  size: 20,
                  color: isSelected
                      ? activeColor
                      : context.textSecondary.withValues(alpha: 0.7)),
              const SizedBox(height: 6),
              Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  color: isSelected ? activeColor : context.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeColor : context.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEventStatus(EventEntity event) {
    try {
      final now = DateTime.now();
      final date = DateTime.parse(event.eventDate);
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return 'active';
      } else if (date.isAfter(now)) {
        return 'upcoming';
      } else {
        return 'past';
      }
    } catch (_) {
      return 'past';
    }
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
            if (state is EventsLoading || state is EventsSubmitting) {
              return const Center(child: AppLoading(size: 80));
            }

            List<EventEntity> allEvents = [];
            if (state is EventsLoaded) {
              allEvents = state.events;
            }

            // Calculate statistics
            final totalCount = allEvents.length;
            final eventsCount =
                allEvents.where((e) => e.type == 'event').length;
            final articlesCount =
                allEvents.where((e) => e.type == 'article').length;
            final announcementsCount =
                allEvents.where((e) => e.type == 'announcement').length;

            // Apply filters & Sort
            var filteredEvents = allEvents;
            final query = _searchController.text.trim().toLowerCase();
            if (query.isNotEmpty) {
              filteredEvents = filteredEvents
                  .where((e) => e.title.toLowerCase().contains(query))
                  .toList();
            }

            if (_selectedType != 'all') {
              filteredEvents =
                  filteredEvents.where((e) => e.type == _selectedType).toList();
            }

            if (_selectedStatus != 'all') {
              filteredEvents = filteredEvents
                  .where((e) => _getEventStatus(e) == _selectedStatus)
                  .toList();
            }

            if (_selectedSort == 'newest') {
              filteredEvents.sort((a, b) => b.eventDate.compareTo(a.eventDate));
            } else {
              filteredEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
            }

            // Split events into groups
            final eventsList =
                filteredEvents.where((e) => e.type == 'event').toList();
            final articlesList =
                filteredEvents.where((e) => e.type == 'article').toList();
            final announcementsList =
                filteredEvents.where((e) => e.type == 'announcement').toList();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section 1: Thống kê tổng quan ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        _buildStatCard('Tất cả', '$totalCount',
                            LucideIcons.package, context.primary,
                            typeKey: 'all'),
                        const SizedBox(width: 8),
                        _buildStatCard('Sự kiện', '$eventsCount',
                            LucideIcons.calendar, context.accent,
                            typeKey: 'event'),
                        const SizedBox(width: 8),
                        _buildStatCard('Tin tức', '$articlesCount',
                            LucideIcons.fileText, context.primary,
                            typeKey: 'article'),
                        const SizedBox(width: 8),
                        _buildStatCard('Thông báo', '$announcementsCount',
                            LucideIcons.megaphone, context.accent,
                            typeKey: 'announcement'),
                      ],
                    ),
                  ),

                  // ── Section 2: Filters Row ──
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 14, color: context.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm bài viết...',
                              hintStyle: GoogleFonts.beVietnamPro(
                                  fontSize: 14,
                                  color: context.textSecondary
                                      .withValues(alpha: 0.6)),
                              prefixIcon: Icon(LucideIcons.search,
                                  size: 16, color: context.textSecondary),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() {
                                  _selectedSort = _selectedSort == 'newest'
                                      ? 'oldest'
                                      : 'newest';
                                }),
                                icon: Icon(
                                  _selectedSort == 'newest'
                                      ? LucideIcons.arrowDownNarrowWide
                                      : LucideIcons.arrowUpNarrowWide,
                                  size: 18,
                                  color: context.primary,
                                ),
                                tooltip: _selectedSort == 'newest'
                                    ? 'Mới nhất'
                                    : 'Cũ nhất',
                              ),
                              filled: true,
                              fillColor: context.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: context.textSecondary
                                        .withValues(alpha: 0.2)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: context.primary, width: 1.2),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Group 1: SỰ KIỆN ──
                  if (_selectedType == 'all' || _selectedType == 'event') ...[
                    _buildSectionHeader('SỰ KIỆN', eventsList.length),
                    _buildEventsList(eventsList, canEdit),
                  ],

                  // ── Group 2: TIN TỨC ──
                  if (_selectedType == 'all' || _selectedType == 'article') ...[
                    _buildSectionHeader('TIN TỨC', articlesList.length),
                    _buildArticlesList(articlesList, canEdit),
                  ],

                  // ── Group 3: THÔNG BÁO ──
                  if (_selectedType == 'all' ||
                      _selectedType == 'announcement') ...[
                    _buildSectionHeader('THÔNG BÁO', announcementsList.length),
                    _buildAnnouncementsList(announcementsList, canEdit),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Container(
            width: 3.5,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
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
        ],
      ),
    );
  }

  String _formatEventDate(EventEntity event) {
    if (event.eventDate.isEmpty) return '';
    try {
      final parts = event.eventDate.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        final dt = DateTime(year, month, day);
        final dateStr =
            '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
        if (event.isLunar) {
          final lunarStr = LunarDateHelper.getLunarDateString(dt);
          return '$dateStr ($lunarStr)';
        }
        return dateStr;
      }
    } catch (_) {}
    return event.eventDate;
  }

  // ── Render Group 1: Sự kiện ──
  Widget _buildEventsList(List<EventEntity> list, bool canEdit) {
    if (list.isEmpty) return _buildEmptyGroupMessage();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            list.map((event) => _buildEventItemCard(event, canEdit)).toList(),
      ),
    );
  }

  // ── Render Group 2: Tin tức ──
  Widget _buildArticlesList(List<EventEntity> list, bool canEdit) {
    if (list.isEmpty) return _buildEmptyGroupMessage();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            list.map((event) => _buildArticleItemCard(event, canEdit)).toList(),
      ),
    );
  }

  // ── Render Group 3: Thông báo ──
  Widget _buildAnnouncementsList(List<EventEntity> list, bool canEdit) {
    if (list.isEmpty) return _buildEmptyGroupMessage();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: list
            .map((event) => _buildAnnouncementItemCard(event, canEdit))
            .toList(),
      ),
    );
  }

  Widget _buildEmptyGroupMessage() {
    return const AppEmptyState(
      message: 'Không có bài viết nào',
      icon: LucideIcons.fileX,
      iconSize: 36,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }

  Widget _buildCardBannerImage(String? imageUrl) {
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();

    Widget defaultLogoFallback = Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              LucideIcons.image,
              size: 36,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );

    if (isNetworkImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => defaultLogoFallback,
        ),
      );
    }

    if (isLocalImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(imageUrl),
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => defaultLogoFallback,
        ),
      );
    }

    return defaultLogoFallback;
  }

  Future<void> _navigateToDetail(EventEntity event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminEventDetailPage(
          familyId: widget.familyId,
          event: event,
        ),
      ),
    );
    if (result == true) _loadEvents();
  }

  // ── Card Item 1: Sự kiện (Layout Dọc) ──
  Widget _buildEventItemCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;

    String statusText = 'Đã kết thúc';
    Color statusColor = Colors.grey;
    final status = _getEventStatus(event);
    if (status == 'active') {
      statusText = 'Đang diễn ra';
      statusColor = Colors.green;
    } else if (status == 'upcoming') {
      statusText = 'Sắp diễn ra';
      statusColor = Colors.blue;
    }

    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Banner (with default logo fallback)
            _buildCardBannerImage(event.imageUrl),
            const SizedBox(height: 12),

            // Status Tag
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                            color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        statusText,
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              event.title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Date
            Row(
              children: [
                Icon(LucideIcons.calendar,
                    size: 13, color: context.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _formatEventDate(event),
                    style: GoogleFonts.inter(
                        fontSize: 12, color: context.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Location (if available)
            if (event.location != null && event.location!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(LucideIcons.mapPin,
                      size: 13, color: context.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.location!,
                      style: GoogleFonts.beVietnamPro(
                          fontSize: 12, color: context.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),

            // Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionOutlineButton(
                  icon: LucideIcons.pencil,
                  label: 'Sửa',
                  onTap: () => _navigateToDetail(event),
                ),
              ],
            ),
          ],
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
        onTap: () => _navigateToDetail(event),
        child: GestureDetector(
          onTap: () => _navigateToDetail(event),
          child: cardContent,
        ),
      );
    }
    return GestureDetector(
      onTap: () => _navigateToDetail(event),
      child: cardContent,
    );
  }

  // ── Card Item 2: Tin tức (Layout Dọc) ──
  Widget _buildArticleItemCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;

    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Banner (with default logo fallback)
            _buildCardBannerImage(event.imageUrl),
            const SizedBox(height: 12),

            // Title
            Text(
              event.title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Date & Author
            Row(
              children: [
                Icon(LucideIcons.calendar,
                    size: 13, color: context.textSecondary),
                const SizedBox(width: 6),
                Text(
                  _formatEventDate(event),
                  style: GoogleFonts.inter(
                      fontSize: 12, color: context.textSecondary),
                ),
                const SizedBox(width: 14),
                Icon(LucideIcons.user,
                    size: 13, color: context.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.organizer ?? 'Admin',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 12, color: context.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionOutlineButton(
                  icon: LucideIcons.pencil,
                  label: 'Sửa',
                  onTap: () => _navigateToDetail(event),
                ),
              ],
            ),
          ],
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
        onTap: () => _navigateToDetail(event),
        child: GestureDetector(
          onTap: () => _navigateToDetail(event),
          child: cardContent,
        ),
      );
    }
    return GestureDetector(
      onTap: () => _navigateToDetail(event),
      child: cardContent,
    );
  }

  // ── Card Item 3: Thông báo ──
  Widget _buildAnnouncementItemCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;

    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: context.textSecondary.withValues(alpha: 0.08),
              child: Icon(
                LucideIcons.bell,
                size: 18,
                color: AppColors.error.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(LucideIcons.calendar,
                          size: 12, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _formatEventDate(event),
                        style: GoogleFonts.inter(
                            fontSize: 10, color: context.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      Icon(LucideIcons.user,
                          size: 12, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        event.organizer ?? 'Admin',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 10, color: context.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Tag & Edit Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Đã hiển thị',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildActionOutlineButton(
                  icon: LucideIcons.pencil,
                  label: 'Sửa',
                  onTap: () => _navigateToDetail(event),
                ),
              ],
            ),
          ],
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
        onTap: () => _navigateToDetail(event),
        child: GestureDetector(
          onTap: () => _navigateToDetail(event),
          child: cardContent,
        ),
      );
    }
    return GestureDetector(
      onTap: () => _navigateToDetail(event),
      child: cardContent,
    );
  }

  Widget _buildActionOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: context.accent.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: context.textPrimary),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
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
            child: Text(l10n.deleteLabel),
          ),
        ],
      ),
    );
  }
}
