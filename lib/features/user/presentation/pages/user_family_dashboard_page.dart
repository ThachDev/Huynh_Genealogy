import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:vnlunar/vnlunar.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

import '../../../family_tree/family_tree.dart';
import '../widgets/user_branch_card.dart';
import '../../../auth/auth.dart';
import '../../../events/events.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../admin/presentation/widgets/admin_dashboard/member_item_widget.dart';
import '../../../admin/presentation/widgets/admin_dashboard/family_dashboard_header_widget.dart';
import '../../../admin/presentation/pages/events/admin_event_detail_page.dart';
import '../../../../core/data/repository/notification_read_controller.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/family_highlight_carousel.dart';
import '../widgets/incense_offering_dialog.dart';
import '../widgets/user_notifications_widget.dart';
import '../../data/source/wish_api_service.dart';
import '../models/wish_message.dart';
import 'user_events_page.dart';
import 'user_anniversary_list_page.dart';
import '../models/upcoming_anniversary.dart';

class UserFamilyDashboardPage extends StatefulWidget {
  const UserFamilyDashboardPage({super.key});

  @override
  State<UserFamilyDashboardPage> createState() =>
      _UserFamilyDashboardPageState();
}

class _UserFamilyDashboardPageState extends State<UserFamilyDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedBranchId;
  final ScrollController _scrollController = ScrollController();
  int _memberLimit = 5;
  String _statusFilter = 'all'; // 'all', 'alive', 'deceased'
  String _genderFilter = 'all'; // 'all', 'male', 'female'

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
    _loadEventsData();
  }

  void _loadEventsData() {
    final familyId = _familyId();
    if (familyId != null) {
      context.read<EventsBloc>().add(LoadEventsEvent(familyId: familyId));
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
      _memberLimit = 5;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _memberLimit += 5;
      });
    }
  }

  int? _familyId() {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.familyId : null;
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
    final birthdays = members
        .where((m) =>
            m.isAlive && m.dateOfBirth != null && m.dateOfBirth!.isNotEmpty)
        .map((m) {
          final today = DateTime.now();
          final parts = m.dateOfBirth!.split('-');
          if (parts.length != 3) return null;
          final month = int.tryParse(parts[1]);
          final day = int.tryParse(parts[2]);
          if (month == null || day == null) {
            return null;
          }
          var bd = DateTime(today.year, month, day);
          if (bd.isBefore(DateTime(today.year, today.month, today.day))) {
            bd = DateTime(today.year + 1, month, day);
          }
          final daysLeft = bd
              .difference(DateTime(today.year, today.month, today.day))
              .inDays;
          return UpcomingAnniversary(
            member: m,
            title: m.fullName,
            solarDateLabel:
                '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}',
            daysRemaining: daysLeft,
            isBirthday: true,
          );
        })
        .whereType<UpcomingAnniversary>()
        .toList()
      ..sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return birthdays;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
        builder: (context, state) {
          return AppBackgroundBody(
            child: Column(
              children: [
                // Header đồng bộ với Admin Dashboard
                _buildHeader(context, state),
                // Content List
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      if (state is FamilyTreeLoading)
                        const SliverFillRemaining(
                          child: UserFamilyDashboardSkeleton(),
                        ),
                      if (state is FamilyTreeError)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.alertCircle,
                                  size: 64,
                                  color: context.primary,
                                ),
                                const SizedBox(height: 16),
                                Text(state.message, style: GoogleFonts.inter()),
                                AppButton(
                                  label: l10n.retryButton,
                                  onPressed: () => context
                                      .read<FamilyTreeBloc>()
                                      .add(FamilyTreeLoadEvent(
                                          familyId: _familyId())),
                                  size: AppButtonSize.small,
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (state is FamilyTreeLoaded) ...[
                        const SliverToBoxAdapter(child: SizedBox(height: 10)),

                        // ── 1. Banner Tiêu Điểm Sắp Tới (Carousel) ──
                        BlocBuilder<EventsBloc, EventsState>(
                          builder: (context, eventsState) {
                            final events = eventsState is EventsLoaded
                                ? eventsState.events
                                : <EventEntity>[];

                            return SliverToBoxAdapter(
                              child: FamilyHighlightCarousel(
                                events: events,
                                members: state.members,
                                onGoToEvents: () {
                                  final famId = _familyId();
                                  if (famId != null) {
                                    Navigator.push(
                                      context,
                                      SereneFadeSlidePageRoute(
                                        page: UserEventsPage(familyId: famId),
                                      ),
                                    );
                                  }
                                },
                                onGoToEventDetail: (event) {
                                  final famId = _familyId();
                                  if (famId != null) {
                                    Navigator.push(
                                      context,
                                      SereneFadeSlidePageRoute(
                                        page: AdminEventDetailPage(
                                          familyId: famId,
                                          event: event,
                                          isUserView: true,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                onGoToAnniversaries: () {
                                  final anniversaries =
                                      _calculateDeathAnniversaries(
                                          state.members);
                                  final birthdays =
                                      _calculateBirthdays(state.members);
                                  Navigator.push(
                                    context,
                                    SereneFadeSlidePageRoute(
                                      page: UserAnniversaryListPage(
                                        deathAnniversaries: anniversaries,
                                        birthdays: birthdays,
                                        initialTabIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                onGoToBirthdays: () {
                                  final anniversaries =
                                      _calculateDeathAnniversaries(
                                          state.members);
                                  final birthdays =
                                      _calculateBirthdays(state.members);
                                  Navigator.push(
                                    context,
                                    SereneFadeSlidePageRoute(
                                      page: UserAnniversaryListPage(
                                        deathAnniversaries: anniversaries,
                                        birthdays: birthdays,
                                        initialTabIndex: 1,
                                      ),
                                    ),
                                  );
                                },
                                onIncenseTap: (name) =>
                                    _showIncenseDialog(context, name),
                              ),
                            );
                          },
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 2)),

                        // ── 2. Branches Section ──
                        SliverToBoxAdapter(
                          child: AppSectionTitle(
                            title: l10n.branchTabLabel,
                            trailing: _selectedBranchId != null
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedBranchId = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: context.primary
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            l10n.clearBranchFilterLabel,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: context.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(LucideIcons.x,
                                              size: 12, color: context.primary),
                                        ],
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: ClipRect(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                height: 140,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  clipBehavior: Clip.none,
                                  itemCount: state.branches.length,
                                  itemBuilder: (_, index) {
                                    final branch = state.branches[index];
                                    final isSelected =
                                        _selectedBranchId == branch.id;
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              index < state.branches.length - 1
                                                  ? 12
                                                  : 0,
                                        ),
                                        child: UserBranchCard(
                                          branch: branch,
                                          isSelected: isSelected,
                                          onTap: () {
                                            setState(() {
                                              if (_selectedBranchId ==
                                                  branch.id) {
                                                _selectedBranchId = null;
                                              } else {
                                                _selectedBranchId = branch.id;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        // ── 4. Members Section Title & Search + Filter ──
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 18,
                                  color: context.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.memberTabLabel.toUpperCase(),
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimary,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // ── Thanh tìm kiếm luôn mở + Nút bộ lọc ──
                                Expanded(
                                  child: Container(
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: context.surface,
                                      borderRadius: BorderRadius.circular(19),
                                      border: Border.all(
                                        color: context.textSecondary
                                            .withValues(alpha: 0.2),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.03),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Icon(
                                          LucideIcons.search,
                                          size: 16,
                                          color: context.textSecondary,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: context.textPrimary,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: l10n.searchMembersHint,
                                              hintStyle: GoogleFonts.inter(
                                                fontSize: 12,
                                                color: context.textSecondary
                                                    .withValues(alpha: 0.6),
                                              ),
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        if (_searchQuery.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              _searchController.clear();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Icon(
                                                LucideIcons.x,
                                                size: 15,
                                                color: context.textSecondary,
                                              ),
                                            ),
                                          ),
                                        // ── Nút Bộ Lọc dạng Switch / Toggle ──
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                          ),
                                          child: PopupMenuButton<void>(
                                            icon: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Icon(
                                                  LucideIcons.listFilter,
                                                  size: 17,
                                                  color: (_statusFilter !=
                                                              'all' ||
                                                          _genderFilter !=
                                                              'all')
                                                      ? context.primary
                                                      : context.textSecondary,
                                                ),
                                                if (_statusFilter != 'all' ||
                                                    _genderFilter != 'all')
                                                  Positioned(
                                                    top: -2,
                                                    right: -2,
                                                    child: Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color: context.primary,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                            offset: const Offset(0, 42),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            color: context.surface,
                                            elevation: 6,
                                            itemBuilder: (context) => [
                                              PopupMenuItem<void>(
                                                enabled: false,
                                                padding: EdgeInsets.zero,
                                                child: StatefulBuilder(
                                                  builder:
                                                      (context, setMenuState) {
                                                    return Container(
                                                      width: 210,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // ── Header Bộ Lọc ──
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Tuỳ chọn',
                                                                style: GoogleFonts
                                                                    .beVietnamPro(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: context
                                                                      .textPrimary,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              if (_statusFilter !=
                                                                      'all' ||
                                                                  _genderFilter !=
                                                                      'all')
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _statusFilter =
                                                                          'all';
                                                                      _genderFilter =
                                                                          'all';
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                    'Đặt lại',
                                                                    style: GoogleFonts
                                                                        .inter(
                                                                      fontSize:
                                                                          11,
                                                                      color: context
                                                                          .accent,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 12),

                                                          // ── 1. Switch: Còn sống / Đã mất ──
                                                          Text(
                                                            'Trạng thái',
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: context
                                                                  .textSecondary,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Container(
                                                            height: 32,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: context
                                                                  .background,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              border: Border.all(
                                                                  color: context
                                                                      .textSecondary
                                                                      .withValues(
                                                                          alpha:
                                                                              0.15)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                _buildSwitchOption(
                                                                  label: l10n
                                                                      .aliveLabel,
                                                                  isSelected:
                                                                      _statusFilter ==
                                                                          'alive',
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _statusFilter = _statusFilter ==
                                                                              'alive'
                                                                          ? 'all'
                                                                          : 'alive';
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                ),
                                                                _buildSwitchOption(
                                                                  label: l10n
                                                                      .deceasedLabel,
                                                                  isSelected:
                                                                      _statusFilter ==
                                                                          'deceased',
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _statusFilter = _statusFilter ==
                                                                              'deceased'
                                                                          ? 'all'
                                                                          : 'deceased';
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 12),

                                                          // ── 2. Switch: Giới tính Nam / Nữ ──
                                                          Text(
                                                            'Giới tính',
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: context
                                                                  .textSecondary,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 6),
                                                          Container(
                                                            height: 32,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: context
                                                                  .background,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              border: Border.all(
                                                                  color: context
                                                                      .textSecondary
                                                                      .withValues(
                                                                          alpha:
                                                                              0.15)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                _buildSwitchOption(
                                                                  label: 'Nam',
                                                                  isSelected:
                                                                      _genderFilter ==
                                                                          'male',
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _genderFilter = _genderFilter ==
                                                                              'male'
                                                                          ? 'all'
                                                                          : 'male';
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                ),
                                                                _buildSwitchOption(
                                                                  label: 'Nữ',
                                                                  isSelected:
                                                                      _genderFilter ==
                                                                          'female',
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _genderFilter = _genderFilter ==
                                                                              'female'
                                                                          ? 'all'
                                                                          : 'female';
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Hiển thị danh sách thành viên được lọc theo tìm kiếm, chi tộc, trạng thái & giới tính
                        Builder(
                          builder: (context) {
                            final filteredMembers = state.members.where((m) {
                              if (_selectedBranchId != null &&
                                  m.branchId != _selectedBranchId) {
                                return false;
                              }
                              if (_statusFilter == 'alive' && !m.isAlive) {
                                return false;
                              }
                              if (_statusFilter == 'deceased' && m.isAlive) {
                                return false;
                              }
                              if (_genderFilter == 'male' &&
                                  m.gender != Gender.male) {
                                return false;
                              }
                              if (_genderFilter == 'female' &&
                                  m.gender != Gender.female) {
                                return false;
                              }
                              if (_searchQuery.isNotEmpty) {
                                final query = _searchQuery.toLowerCase();
                                return m.fullName
                                        .toLowerCase()
                                        .contains(query) ||
                                    (m.branchName != null &&
                                        m.branchName!
                                            .toLowerCase()
                                            .contains(query));
                              }
                              return true;
                            }).toList();

                            if (filteredMembers.isEmpty) {
                              return SliverToBoxAdapter(
                                child: AppEmptyState(
                                  icon: LucideIcons.search,
                                  message: l10n.noMemberFound,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 40, horizontal: 16),
                                ),
                              );
                            }

                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final member = filteredMembers[index];
                                  return MemberItemWidget(
                                    member: member,
                                    allMembers: state.members,
                                    showMenu: false,
                                    useOrnamentalBorder: false,
                                  );
                                },
                                childCount:
                                    filteredMembers.length > _memberLimit
                                        ? _memberLimit
                                        : filteredMembers.length,
                              ),
                            );
                          },
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwitchOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? context.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : context.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FamilyTreeState state) {
    final authState = context.watch<AuthBloc>().state;
    final user = (authState is Authenticated) ? authState.user : null;

    final l10n = AppLocalizations.of(context)!;
    String familyName = l10n.familyTreeTitle;
    String inviteCode = '';
    String? logoUrl;

    if (state is FamilyTreeLoaded) {
      if (state.family != null) {
        if (state.family!.name.isNotEmpty) {
          familyName = state.family!.name;
        }
        inviteCode = state.family!.inviteCode;
        logoUrl = state.family!.logoUrl;
      } else if (state.members.isNotEmpty) {
        final rootMembers = state.members.where(
          (m) => m.generation == 1 || m.parentId == null,
        );
        final rootMember =
            rootMembers.isNotEmpty ? rootMembers.first : state.members.first;
        final parts = rootMember.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = l10n.familyTreeNameFormat(parts.first.toUpperCase());
        }
      }
    }

    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, eventsState) {
        List<EventEntity> allEvents = [];
        if (eventsState is EventsLoaded) {
          allEvents = eventsState.events;
        }

        final announcements = allEvents.where((e) {
          final t = e.type.toLowerCase();
          return t == 'announcement' || t == 'notification' || t == 'thông báo';
        }).toList();

        final unreadCount = announcements
            .where((e) =>
                !NotificationReadController.instance.isRead(e.id.toString()))
            .length;

        final bellButton = IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                LucideIcons.bell,
                color: context.textPrimary,
                size: 20,
              ),
              if (unreadCount > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadCount',
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
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () async {
            final famId = _familyId();
            if (famId != null) {
              await Navigator.push(
                context,
                SereneFadeSlidePageRoute(
                  page: UserNotificationsPage(
                    familyId: famId,
                    announcements: announcements,
                    isAdminMode: false,
                  ),
                ),
              );
              if (mounted) setState(() {});
            }
          },
        );

        return FamilyDashboardHeaderWidget(
          user: user,
          familyName: familyName,
          inviteCode: inviteCode,
          logoUrl: logoUrl,
          isLoading: state is FamilyTreeLoading,
          showRoleTag: false, // Ẩn role tag ở user dashboard theo yêu cầu
          trailingAction: bellButton,
        );
      },
    );
  }

  void _showIncenseDialog(BuildContext context, String targetName) async {
    final result = await showIncenseDialog(
      context,
      targetName: targetName,
      subtitle: 'Tưởng nhớ tiền nhân dòng tộc',
    );
    if (result != null && context.mounted) {
      final authState = context.read<AuthBloc>().state;
      UserEntity? userProfile;

      if (authState is Authenticated) {
        userProfile = authState.user;
      }

      if (userProfile != null) {
        final prayerContent = result.trim().isNotEmpty
            ? result.trim()
            : 'Thắp nén tâm nhang tưởng nhớ tiền nhân thành kính.';

        final newWish = WishMessage(
          id: 0,
          familyId: userProfile.familyId ?? 0,
          memberId: 0,
          senderId: userProfile.id,
          content: prayerContent,
          eventType: 'anniversary',
          createdAt: DateTime.now(),
          senderName: userProfile.fullName,
          senderAvatar: userProfile.avatarUrl,
        );

        final apiService = sl<WishApiService>();
        await apiService.createWish(newWish);
      }

      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: 'Đã thắp nén tâm nhang tưởng nhớ $targetName thành kính!',
          type: SnackBarType.success,
        );
      }
    }
  }
}
