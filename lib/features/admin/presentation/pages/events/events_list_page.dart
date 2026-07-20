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
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final String _selectedType = 'all'; // all, event, article, announcement
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
  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
    return Expanded(
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
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
                color: context.textPrimary,
              ),
            ),
          ],
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
                        _buildStatCard('Tổng bài viết', '$totalCount',
                            LucideIcons.package, Colors.purple),
                        const SizedBox(width: 8),
                        _buildStatCard('Sự kiện', '$eventsCount',
                            LucideIcons.calendar, Colors.green),
                        const SizedBox(width: 8),
                        _buildStatCard('Tin tức', '$articlesCount',
                            LucideIcons.fileText, Colors.orange),
                        const SizedBox(width: 8),
                        _buildStatCard('Thông báo', '$announcementsCount',
                            LucideIcons.megaphone, Colors.blue),
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
                            style: GoogleFonts.beVietnamPro(fontSize: 14, color: context.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm bài viết...',
                              hintStyle: GoogleFonts.beVietnamPro(
                                  fontSize: 14, color: context.textSecondary.withValues(alpha: 0.6)),
                              prefixIcon: Icon(LucideIcons.search,
                                  size: 16, color: context.textSecondary),
                              filled: true,
                              fillColor: context.surface,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: context.textSecondary.withValues(alpha: 0.2)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: context.primary, width: 1.2),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 120,
                          child: AppDropdown<String>(
                            value: _selectedSort,
                            items: const [
                              DropdownItem(
                                  value: 'newest', child: Text('Mới nhất')),
                              DropdownItem(
                                  value: 'oldest', child: Text('Cũ nhất')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedSort = val);
                              }
                            },
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
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
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: context.primary,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Xem tất cả',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 11,
                    color: context.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(LucideIcons.chevronRight,
                    size: 12, color: context.primary),
              ],
            ),
          ),
        ],
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        'Không có bài viết nào trong mục này.',
        style: GoogleFonts.beVietnamPro(
            fontSize: 12,
            color: context.textSecondary,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  // ── Card Item 1: Sự kiện ──
  Widget _buildEventItemCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    String statusText = 'Đã kết thúc';
    Color statusColor = Colors.grey;
    final status = _getEventStatus(event);
    if (status == 'active') {
      statusText = 'Đang diễn ra';
      statusColor = Colors.green;
    } else if (status == 'upcoming') {
      statusText = 'Sắp diễn ra';
      statusColor = Colors.orange;
    }

    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Image
            if (hasImage)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: isNetworkImage
                        ? NetworkImage(imageUrl)
                        : FileImage(File(imageUrl)) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(LucideIcons.image, size: 24, color: context.primary),
              ),
            const SizedBox(width: 12),

            // Right Info details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Status tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: statusColor, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusText,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // View count
                      Row(
                        children: [
                          Icon(LucideIcons.eye,
                              size: 10, color: context.textSecondary),
                          const SizedBox(width: 4),
                          Text('1.256',
                              style: GoogleFonts.inter(
                                  fontSize: 9, color: context.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
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
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${event.eventDate}  •  158 người đăng ký',
                          style: GoogleFonts.inter(
                              fontSize: 10, color: context.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin,
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location ?? 'Nhà thờ họ',
                          style: GoogleFonts.beVietnamPro(
                              fontSize: 10, color: context.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionOutlineButton(
                        icon: LucideIcons.pencil,
                        label: 'Sửa',
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
                          if (result == true) _loadEvents();
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildActionOutlineButton(
                        icon: LucideIcons.moreHorizontal,
                        label: 'Khác',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
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
        onTap: () {},
        child: cardContent,
      );
    }
    return cardContent;
  }

  // ── Card Item 2: Tin tức ──
  Widget _buildArticleItemCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = event.imageUrl;
    final isNetworkImage = imageUrl != null &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final isLocalImage =
        imageUrl != null && !isNetworkImage && File(imageUrl).existsSync();
    final hasImage = isNetworkImage || isLocalImage;

    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Image
            if (hasImage)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: isNetworkImage
                        ? NetworkImage(imageUrl)
                        : FileImage(File(imageUrl)) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(LucideIcons.image, size: 24, color: context.primary),
              ),
            const SizedBox(width: 12),

            // Right Info details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      // View count
                      Row(
                        children: [
                          Icon(LucideIcons.eye,
                              size: 10, color: context.textSecondary),
                          const SizedBox(width: 4),
                          Text('632',
                              style: GoogleFonts.inter(
                                  fontSize: 9, color: context.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
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
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        event.eventDate,
                        style: GoogleFonts.inter(
                            fontSize: 10, color: context.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.user,
                          size: 11, color: context.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'Admin',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 10, color: context.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Action Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionOutlineButton(
                        icon: LucideIcons.pencil,
                        label: 'Sửa',
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AdminEventDetailPage(
                                      familyId: widget.familyId,
                                      event: event,
                                    )),
                          );
                          if (result == true) _loadEvents();
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildActionOutlineButton(
                        icon: LucideIcons.moreHorizontal,
                        label: 'Khác',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
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
        onTap: () {},
        child: cardContent,
      );
    }
    return cardContent;
  }

  // ── Card Item 3: Thông báo ──
  Widget _buildAnnouncementItemCard(EventEntity event, bool canEdit) {
    final l10n = AppLocalizations.of(context)!;
    Widget cardContent = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TraditionalOrnamentalCard(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: context.primary.withValues(alpha: 0.1),
              child: Icon(LucideIcons.bell, size: 16, color: context.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(LucideIcons.calendar,
                          size: 10, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        event.eventDate,
                        style: GoogleFonts.inter(
                            fontSize: 9, color: context.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      Icon(LucideIcons.user,
                          size: 10, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        'Admin',
                        style: GoogleFonts.beVietnamPro(
                            fontSize: 9, color: context.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Tag & View count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Đã hiển thị',
                    style: GoogleFonts.beVietnamPro(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.eye,
                        size: 10, color: context.textSecondary),
                    const SizedBox(width: 4),
                    Text('356',
                        style: GoogleFonts.inter(
                            fontSize: 9, color: context.textSecondary)),
                    const SizedBox(width: 4),
                    Icon(LucideIcons.moreVertical,
                        size: 12, color: context.textSecondary),
                  ],
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
        onTap: () {},
        child: cardContent,
      );
    }
    return cardContent;
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
