import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../../../family_tree/family_tree.dart';
import '../widgets/user_branch_card.dart';
import '../../../auth/auth.dart';
import '../../../../core/widgets/widgets.dart';

class FamilyEvent {
  final String title;
  final String type;
  final String date;
  final String countdown;
  final int generation;
  final Color badgeColor;

  FamilyEvent({
    required this.title,
    required this.type,
    required this.date,
    required this.countdown,
    required this.generation,
    required this.badgeColor,
  });
}

class UserFamilyDashboardPage extends StatefulWidget {
  const UserFamilyDashboardPage({super.key});

  @override
  State<UserFamilyDashboardPage> createState() =>
      _UserFamilyDashboardPageState();
}

class _UserFamilyDashboardPageState extends State<UserFamilyDashboardPage> {
  int? _selectedBranchId;
  final TextEditingController _searchController = TextEditingController();
  String _selectedGender = 'Tất cả';
  final ScrollController _scrollController = ScrollController();

  int? _familyId() {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.familyId : null;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      body: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
        builder: (context, state) {
          final double topPadding = MediaQuery.of(context).padding.top;
          final double offset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          final double headerHeight = (200.0 + topPadding - offset)
              .clamp(56.0 + topPadding, 200.0 + topPadding);
          final double searchBarTop = headerHeight - 25.0;
          final double opacity =
              ((headerHeight - (56.0 + topPadding)) / 60.0).clamp(0.0, 1.0);

          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // ── Wooden Header with Dragon Patterns ──
                  _buildHeader(context, state),
                  if (state is FamilyTreeLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: AppLoading(size: 80),
                      ),
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
                    // ── Spacer for Floating Search Bar ──
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 25),
                    ),
                    // ── Events/Anniversaries Carousel ──
                    SliverToBoxAdapter(
                      child: _buildEventsCarousel(),
                    ),
                    // ── Branches Section ──
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(l10n.branchTabLabel),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: state.branches.length,
                          itemBuilder: (_, index) {
                            final branch = state.branches[index];
                            return SizedBox(
                              width: 220,
                              child: UserBranchCard(
                                branch: branch,
                                isSelected: _selectedBranchId == branch.id,
                                onTap: () {
                                  setState(() => _selectedBranchId = branch.id);
                                  context.read<FamilyTreeBloc>().add(
                                        FamilyTreeFilterByBranchEvent(
                                            branch.id),
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // ── Members Grid ──
                    SliverToBoxAdapter(
                        child: _buildSectionTitle(l10n.memberTabLabel)),

                    // Local filter block
                    () {
                      final search =
                          _searchController.text.toLowerCase().trim();
                      final filteredMembers = state.members.where((member) {
                        if (_selectedGender != 'Tất cả') {
                          final isMale = member.gender == Gender.male;
                          final isFemale = member.gender == Gender.female;
                          if (_selectedGender == 'Nam' && !isMale) {
                            return false;
                          }
                          if (_selectedGender == 'Nữ' && !isFemale) {
                            return false;
                          }
                        }
                        if (search.isNotEmpty) {
                          final matchesName =
                              member.fullName.toLowerCase().contains(search);
                          final matchesBirth =
                              member.dateOfBirth?.contains(search) ?? false;
                          final matchesBranch = member.branchName
                                  ?.toLowerCase()
                                  .contains(search) ??
                              false;
                          if (!matchesName && !matchesBirth && !matchesBranch) {
                            return false;
                          }
                        }
                        return true;
                      }).toList();

                      if (filteredMembers.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                l10n.noMemberFound,
                                style: TextStyle(color: context.textSecondary),
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisExtent: 90,
                            mainAxisSpacing: 10,
                          ),
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            final member = filteredMembers[index];
                            return _buildMemberCard(member);
                          }, childCount: filteredMembers.length),
                        ),
                      );
                    }(),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ],
              ),
              if (state is FamilyTreeLoaded)
                Positioned(
                  top: searchBarTop,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: opacity,
                    child: Visibility(
                      visible: opacity > 0.05,
                      child: _buildSearchAndFilterSection(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return context.primary;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  String _getRoleLabel(String role) {
    final l10n = AppLocalizations.of(context)!;
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return l10n.roleOwner;
      case 'BRANCH_ADMIN':
        return l10n.roleBranchAdminTitle.toUpperCase();
      case 'EDITOR':
        return l10n.roleEditorTitle.toUpperCase();
      default:
        return l10n.roleViewerTitle.toUpperCase();
    }
  }

  Widget _buildHeader(BuildContext context, FamilyTreeState state) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    String familyName = l10n.familyTreeTitle;
    if (state is FamilyTreeLoaded && state.members.isNotEmpty) {
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

    final now = DateTime.now();
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: context.appBarBg,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Wood Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/wood_dragon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: context.appBarBg),
              ),
            ),
            // Wood Overlay to darken
            Positioned.fill(
              child: Container(
                  color: context.resolve(Colors.black.withValues(alpha: 0.45),
                      Colors.transparent)),
            ),
            // Content
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo + Family Name + Role Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: context.accent, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                            color: context.background.withValues(alpha: 0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(LucideIcons.gitBranch,
                                      color: context.accent, size: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  familyName,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.accent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                if (user != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(user.role),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: context.accent
                                            .withValues(alpha: 0.5),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      _getRoleLabel(user.role),
                                      style: GoogleFonts.inter(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Motto
                    Text(
                      l10n.spiritualMotto,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: context.accent.withValues(alpha: 0.9),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Date
                    Text(
                      l10n.currentDateDisplay(now.day, now.month, now.year),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.users,
                            color: context.accent, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          l10n.memberCountBadge(state is FamilyTreeLoaded
                              ? state.members.length
                              : 0),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(width: 1, height: 12, color: Colors.white30),
                        const SizedBox(width: 24),
                        Icon(LucideIcons.gitBranch,
                            color: context.accent, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          l10n.branchCountLabel(state is FamilyTreeLoaded
                              ? state.branches.length
                              : 0),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsCarousel() {
    final l10n = AppLocalizations.of(context)!;
    final events = [
      FamilyEvent(
        title: l10n.eventSample1,
        type: l10n.eventTypeAncestors,
        date: l10n.eventDateSample1,
        countdown: l10n.todayLabel,
        generation: 2,
        badgeColor: context.primary,
      ),
      FamilyEvent(
        title: l10n.eventSample2,
        type: l10n.eventTypeEvent,
        date: l10n.eventDateSample2,
        countdown: l10n.eventCountdown(2),
        generation: 0,
        badgeColor: Colors.teal,
      ),
      FamilyEvent(
        title: 'Giỗ cụ bà Nguyễn Thị Mai',
        type: l10n.eventTypeAncestors,
        date: '02/07 Âm lịch',
        countdown: l10n.eventCountdown(15),
        generation: 3,
        badgeColor: Colors.orange,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.eventsSectionTitle),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: context.accent.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: context.resolve(
                          Colors.black.withValues(alpha: 0.02),
                          Colors.transparent),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: event.badgeColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.type,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: event.badgeColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.countdown,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: context.appBarBg,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    Text(
                      event.generation > 0
                          ? l10n.eventDetailFormat(event.generation, event.date)
                          : l10n.eventDateLabel(event.date),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterSection() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: context.accent.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: context.resolve(
                  Colors.black.withValues(alpha: 0.08), Colors.transparent),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(LucideIcons.search, color: context.accent, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l10n.searchMemberYearHint,
                  hintStyle: GoogleFonts.inter(
                    color: context.textSecondary.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: context.accent.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 4),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                icon: Icon(
                  LucideIcons.chevronsUpDown,
                  color: context.accent,
                  size: 14,
                ),
                dropdownColor: context.surface,
                style: GoogleFonts.inter(
                  color: context.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                items: ['Tất cả', 'Nam', 'Nữ'].map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedGender = val);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(width: 4, height: 18, color: context.primary),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberEntity m) {
    final l10n = AppLocalizations.of(context)!;
    final bool isMale = m.gender == Gender.male;
    final String genText = m.generation != null
        ? l10n.generationBadge('${m.generation}')
        : l10n.unknownGeneration;
    final String statusText = m.isAlive ? l10n.aliveLabel : l10n.deceasedLabel;
    final Color statusColor = m.isAlive ? Colors.green : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMale
              ? context.nodeMale.withValues(alpha: 0.3)
              : context.nodeFemale.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.resolve(
                Colors.black.withValues(alpha: 0.03), Colors.transparent),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                color: isMale ? context.nodeMale : context.nodeFemale,
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: isMale
                      ? context.nodeMale.withValues(alpha: 0.1)
                      : context.nodeFemale.withValues(alpha: 0.1),
                  radius: 24,
                  backgroundImage:
                      m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null,
                  child: m.avatarUrl == null
                      ? Icon(
                          isMale ? LucideIcons.user : LucideIcons.userCheck,
                          color: isMale ? context.nodeMale : context.nodeFemale,
                          size: 20,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      m.fullName,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genText,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: context.appBarBg,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          m.branchName ?? l10n.unassignedBranch,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    icon: Icon(LucideIcons.chevronRight,
                        color: context.accent, size: 20),
                    onPressed: () {
                      // Action details
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
