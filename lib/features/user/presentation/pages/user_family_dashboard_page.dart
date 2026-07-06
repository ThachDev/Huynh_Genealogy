import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:giatocviet/core/domain/entity/member_entity.dart';
import '../bloc/user_tree_bloc.dart';
import '../widgets/user_branch_card.dart';
import '../../../auth/auth.dart';
import '../../../family_fund/family_fund.dart';

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
    context.read<UserTreeBloc>().add(UserTreeLoadEvent(familyId: _familyId()));
    context.read<FamilyFundBloc>().add(FetchFundSummary());
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
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: BlocBuilder<UserTreeBloc, UserTreeState>(
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
                  if (state is UserTreeLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.crimson),
                      ),
                    ),
                  if (state is UserTreeError)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LucideIcons.alertCircle,
                              size: 64,
                              color: AppColors.crimson,
                            ),
                            const SizedBox(height: 16),
                            Text(state.message, style: GoogleFonts.inter()),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<UserTreeBloc>()
                                  .add(UserTreeLoadEvent(familyId: _familyId())),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (state is UserTreeLoaded) ...[
                    // ── Spacer for Floating Search Bar ──
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 25),
                    ),
                    // ── Family Fund Card ──
                    SliverToBoxAdapter(
                      child: _buildFundCard(),
                    ),
                    // ── Events/Anniversaries Carousel ──
                    SliverToBoxAdapter(
                      child: _buildEventsCarousel(),
                    ),
                    // ── Branches Section ──
                    SliverToBoxAdapter(
                      child: _buildSectionTitle('Chi Tộc / Nhánh'),
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
                                  context.read<UserTreeBloc>().add(
                                        UserTreeFilterByBranchEvent(branch.id),
                                      );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // ── Members Grid ──
                    SliverToBoxAdapter(child: _buildSectionTitle('Thành Viên')),

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
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'Không tìm thấy thành viên phù hợp',
                                style:
                                    TextStyle(color: AppColors.textSecondary),
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
              if (state is UserTreeLoaded)
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
        return AppColors.crimson;
      case 'BRANCH_ADMIN':
      case 'EDITOR':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  String _getRoleLabel(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
      case 'CREATOR':
        return 'TRƯỞNG TỘC';
      case 'BRANCH_ADMIN':
        return 'QUẢN TRỊ CHI';
      case 'EDITOR':
        return 'BIÊN SOẠN';
      default:
        return 'THÀNH VIÊN';
    }
  }

  Widget _buildHeader(BuildContext context, UserTreeState state) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    String familyName = 'GIA PHẢ DÒNG HỌ';
    if (state is UserTreeLoaded && state.members.isNotEmpty) {
      final rootMembers = state.members.where(
        (m) => m.generation == 1 || m.parentId == null,
      );
      final rootMember =
          rootMembers.isNotEmpty ? rootMembers.first : state.members.first;
      final parts = rootMember.fullName.trim().split(' ');
      if (parts.isNotEmpty) {
        familyName = 'GIA PHẢ HỌ ${parts.first.toUpperCase()}';
      }
    }

    final now = DateTime.now();
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.wood,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Wood Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/wood_dragon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.wood),
              ),
            ),
            // Wood Overlay to darken
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.45)),
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
                                Border.all(color: AppColors.gold, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.parchment.withValues(alpha: 0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(LucideIcons.gitBranch,
                                      color: AppColors.gold, size: 24),
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
                                    color: AppColors.gold,
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
                                        color: AppColors.gold
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
                      'CỘI NGUỒN TÂM LINH • VẠN ĐẠI TRƯỜNG TỒN',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gold.withValues(alpha: 0.9),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Date
                    Text(
                      'Ngày ${now.day}/${now.month}/${now.year} (Nhằm 12/05 Âm Lịch)',
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
                        const Icon(LucideIcons.users,
                            color: AppColors.gold, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${state is UserTreeLoaded ? state.members.length : 0} Thành viên',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(width: 1, height: 12, color: Colors.white30),
                        const SizedBox(width: 24),
                        const Icon(LucideIcons.gitBranch,
                            color: AppColors.gold, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${state is UserTreeLoaded ? state.branches.length : 0} Chi tộc',
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

  Widget _buildFundCard() {
    return BlocBuilder<FamilyFundBloc, FamilyFundState>(
      builder: (context, state) {
        final balanceText = state is FamilyFundLoaded
            ? NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(state.balance)
            : '0 ₫';
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.wallet,
                          color: AppColors.gold, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'QUỸ GIA TỘC',
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          color: AppColors.wood,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    balanceText,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.crimson,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FamilyFundPage(isAdmin: false),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.wood,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(LucideIcons.heartHandshake, size: 14),
                label: Text(
                  'Đóng góp',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventsCarousel() {
    final events = [
      FamilyEvent(
        title: 'Giỗ cụ Huỳnh Công Minh',
        type: 'Giỗ Chạp',
        date: '12/05 Âm lịch',
        countdown: 'Hôm nay',
        generation: 2,
        badgeColor: AppColors.crimson,
      ),
      FamilyEvent(
        title: 'Hội thảo Dòng họ Xuân 2026',
        type: 'Sự kiện',
        date: '28/06 Dương lịch',
        countdown: 'Còn 2 ngày',
        generation: 0,
        badgeColor: Colors.teal,
      ),
      FamilyEvent(
        title: 'Giỗ cụ bà Nguyễn Thị Mai',
        type: 'Giỗ Chạp',
        date: '02/07 Âm lịch',
        countdown: 'Còn 15 ngày',
        generation: 3,
        badgeColor: Colors.orange,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sự Kiện & Lễ Giỗ Dòng Họ'),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
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
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            event.countdown,
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.wood,
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      event.generation > 0
                          ? 'Đời thứ ${event.generation} • Ngày ${event.date}'
                          : 'Ngày ${event.date}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(LucideIcons.search, color: AppColors.gold, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Tìm thành viên, năm sinh...',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: AppColors.gold.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 4),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                icon: const Icon(
                  LucideIcons.chevronsUpDown,
                  color: AppColors.gold,
                  size: 14,
                ),
                dropdownColor: Colors.white,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
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
          Container(width: 4, height: 18, color: AppColors.crimson),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberEntity m) {
    final bool isMale = m.gender == Gender.male;
    final String genText =
        m.generation != null ? 'Đời ${m.generation}' : 'Chưa rõ đời';
    final String statusText = m.isAlive ? 'Còn sống' : 'Đã mất';
    final Color statusColor = m.isAlive ? Colors.green : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMale
              ? AppColors.nodeMale.withValues(alpha: 0.3)
              : AppColors.nodeFemale.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                color: isMale ? AppColors.nodeMale : AppColors.nodeFemale,
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: isMale
                      ? AppColors.nodeMale.withValues(alpha: 0.1)
                      : AppColors.nodeFemale.withValues(alpha: 0.1),
                  radius: 24,
                  backgroundImage:
                      m.avatarUrl != null ? NetworkImage(m.avatarUrl!) : null,
                  child: m.avatarUrl == null
                      ? Icon(
                          isMale ? LucideIcons.user : LucideIcons.userCheck,
                          color: isMale
                              ? AppColors.nodeMale
                              : AppColors.nodeFemale,
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genText,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.wood,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          m.branchName ?? 'Chưa phân chi',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
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
                    icon: const Icon(LucideIcons.chevronRight,
                        color: AppColors.gold, size: 20),
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
