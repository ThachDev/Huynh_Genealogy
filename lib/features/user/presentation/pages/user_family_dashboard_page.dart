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
import '../../../admin/presentation/widgets/admin_dashboard/member_item_widget.dart';

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
          final double headerHeight = 200.0 + topPadding;

          return Stack(
            children: [
              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeader(context, state, headerHeight),
              ),
              // Content Panel
              Positioned(
                top: headerHeight + 35.0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.background,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
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
                        // Spacer for Search Section overlapping
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 25),
                        ),
                        // ── Branches Section ──
                        SliverToBoxAdapter(
                          child: AppSectionTitle(title: l10n.branchTabLabel),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: state.branches.length,
                              itemBuilder: (_, index) {
                                final branch = state.branches[index];
                                return SizedBox(
                                  width: 220,
                                  child: UserBranchCard(
                                    branch: branch,
                                    isSelected: _selectedBranchId == branch.id,
                                    onTap: () {
                                      setState(
                                          () => _selectedBranchId = branch.id);
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
                          child: AppSectionTitle(title: l10n.memberTabLabel),
                        ),
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
                              final matchesName = member.fullName
                                  .toLowerCase()
                                  .contains(search);
                              final matchesBirth =
                                  member.dateOfBirth?.contains(search) ?? false;
                              final matchesBranch = member.branchName
                                      ?.toLowerCase()
                                      .contains(search) ??
                                  false;
                              if (!matchesName &&
                                  !matchesBirth &&
                                  !matchesBranch) {
                                return false;
                              }
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
                                );
                              },
                              childCount: filteredMembers.length,
                            ),
                          );
                        }(),
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                      ],
                    ],
                  ),
                ),
              ),
              // Search & Filter Section
              if (state is FamilyTreeLoaded)
                Positioned(
                  top: headerHeight - 25.0,
                  left: 0,
                  right: 0,
                  child: _buildSearchAndFilterSection(),
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

  Widget _buildHeader(
      BuildContext context, FamilyTreeState state, double height) {
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
    return Container(
      height: height,
      color: context.appBarBg,
      child: Stack(
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
                color: context.resolve(
                    Colors.black.withValues(alpha: 0.45), Colors.transparent)),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                          border: Border.all(color: context.accent, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                          color: context.background.withValues(alpha: 0.1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                                LucideIcons.gitBranch,
                                color: context.accent,
                                size: 24),
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
                                      color:
                                          context.accent.withValues(alpha: 0.5),
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
                      Icon(LucideIcons.users, color: context.accent, size: 14),
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
}
