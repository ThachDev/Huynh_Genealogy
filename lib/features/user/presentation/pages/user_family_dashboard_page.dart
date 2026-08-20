import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../family_tree/family_tree.dart';
import '../widgets/user_branch_card.dart';
import '../../../auth/auth.dart';
import '../../../events/events.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../admin/presentation/widgets/admin_dashboard/member_item_widget.dart';
import '../../../admin/presentation/widgets/admin_dashboard/family_dashboard_header_widget.dart';

import '../../../../core/di/injection_container.dart';
import '../widgets/family_highlight_carousel.dart';
import '../widgets/incense_offering_dialog.dart';
import '../widgets/user_notifications_widget.dart';
import '../../domain/repository/wish_repository.dart';
import '../../domain/entities/wish_entity.dart';
import 'user_anniversary_list_page.dart';
import '../../domain/services/anniversary_calculator.dart';
import '../../domain/services/member_filter.dart';
import '../../domain/services/announcement_service.dart';

class UserFamilyDashboardPage extends StatefulWidget {
  const UserFamilyDashboardPage({super.key});

  @override
  State<UserFamilyDashboardPage> createState() =>
      _UserFamilyDashboardPageState();
}

class _UserFamilyDashboardPageState extends State<UserFamilyDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _memberLimit = 5;
  MemberFilter _filter = const MemberFilter();

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
      _filter = _filter.copyWith(
          searchQuery: _searchController.text.trim().toLowerCase());
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                                  UserMainNavigationPage
                                      .tabIndexNotifier.value = 1;
                                },
                                onGoToEventDetail: (event) {
                                  UserMainNavigationPage
                                      .tabIndexNotifier.value = 1;
                                },
                                onGoToAnniversaries: () =>
                                    _openAnniversaryList(state.members),
                                onGoToBirthdays: () => _openAnniversaryList(
                                  state.members,
                                  initialTabIndex: 1,
                                ),
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
                            trailing: _filter.branchId != null
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _filter = _filter.copyWith();
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
                                        _filter.branchId == branch.id;
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
                                              if (_filter.branchId ==
                                                  branch.id) {
                                                _filter = _filter.copyWith();
                                              } else {
                                                _filter = _filter.copyWith(
                                                    branchId: branch.id);
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
                                  l10n.statMembers.toUpperCase(),
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
                                        if (_filter.searchQuery.isNotEmpty)
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
                                                  color: _filter
                                                          .hasActiveFilters
                                                      ? context.primary
                                                      : context.textSecondary,
                                                ),
                                                if (_filter.hasActiveFilters)
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
                                                                l10n.optionsLabel,
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
                                                              if (_filter
                                                                  .hasActiveFilters)
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _filter =
                                                                          const MemberFilter();
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                  child: Text(
                                                                    l10n.resetFilterLabel,
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
                                                            l10n.statusLabel,
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
                                                                  isSelected: _filter
                                                                          .status ==
                                                                      MemberStatusFilter
                                                                          .alive,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _filter =
                                                                          _filter
                                                                              .copyWith(
                                                                        status: _filter.status ==
                                                                                MemberStatusFilter.alive
                                                                            ? MemberStatusFilter.all
                                                                            : MemberStatusFilter.alive,
                                                                      );
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                ),
                                                                _buildSwitchOption(
                                                                  label: l10n
                                                                      .deceasedLabel,
                                                                  isSelected: _filter
                                                                          .status ==
                                                                      MemberStatusFilter
                                                                          .deceased,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _filter =
                                                                          _filter
                                                                              .copyWith(
                                                                        status: _filter.status ==
                                                                                MemberStatusFilter.deceased
                                                                            ? MemberStatusFilter.all
                                                                            : MemberStatusFilter.deceased,
                                                                      );
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
                                                            l10n.genderLabel,
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
                                                                      .genderMale,
                                                                  isSelected: _filter
                                                                          .gender ==
                                                                      MemberGenderFilter
                                                                          .male,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _filter =
                                                                          _filter
                                                                              .copyWith(
                                                                        gender: _filter.gender ==
                                                                                MemberGenderFilter.male
                                                                            ? MemberGenderFilter.all
                                                                            : MemberGenderFilter.male,
                                                                      );
                                                                    });
                                                                    setMenuState(
                                                                        () {});
                                                                  },
                                                                ),
                                                                _buildSwitchOption(
                                                                  label: l10n
                                                                      .genderFemale,
                                                                  isSelected: _filter
                                                                          .gender ==
                                                                      MemberGenderFilter
                                                                          .female,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _filter =
                                                                          _filter
                                                                              .copyWith(
                                                                        gender: _filter.gender ==
                                                                                MemberGenderFilter.female
                                                                            ? MemberGenderFilter.all
                                                                            : MemberGenderFilter.female,
                                                                      );
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
                            final filteredMembers =
                                _filter.apply(state.members);

                            if (filteredMembers.isEmpty) {
                              return SliverToBoxAdapter(
                                child: AppEmptyState(
                                  icon: LucideIcons.search,
                                  message: l10n.emptyMembers,
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

    final l10n = AppLocalizations.of(context);
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
        final surname = FamilyNameResolver.resolveSurname(state.members);
        if (surname != null) {
          familyName = l10n.familyTreeNameFormat(surname.toUpperCase());
        }
      }
    }

    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, eventsState) {
        List<EventEntity> allEvents = [];
        if (eventsState is EventsLoaded) {
          allEvents = eventsState.events;
        }

        final headerData = AnnouncementService.buildHeaderData(
          allEvents,
          NotificationReadController.instance,
        );

        final bellButton = IconButton(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                LucideIcons.bell,
                color: context.textPrimary,
                size: 20,
              ),
              if (headerData.hasUnread)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: context.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${headerData.unreadCount}',
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
                    announcements: headerData.announcements,
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
          trailingAction: bellButton,
        );
      },
    );
  }

  void _openAnniversaryList(
    List<MemberEntity> members, {
    int initialTabIndex = 0,
  }) {
    final anniversaries =
        AnniversaryCalculator.calculateDeathAnniversaries(members);
    final birthdays = AnniversaryCalculator.calculateBirthdays(members);
    Navigator.push(
      context,
      SereneFadeSlidePageRoute(
        page: UserAnniversaryListPage(
          deathAnniversaries: anniversaries,
          birthdays: birthdays,
          initialTabIndex: initialTabIndex,
        ),
      ),
    );
  }

  void _showIncenseDialog(BuildContext context, String targetName) async {
    final l10n = AppLocalizations.of(context);
    final result = await showIncenseDialog(
      context,
      targetName: targetName,
      subtitle: l10n.incenseSubtitleRemember,
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
            : l10n.incenseDefaultPrayer;

        final newWish = WishEntity(
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

        final wishRepo = sl<WishRepository>();
        await wishRepo.createWish(newWish);
      }

      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: l10n.incenseLitFor(targetName),
          type: SnackBarType.success,
        );
      }
    }
  }
}
