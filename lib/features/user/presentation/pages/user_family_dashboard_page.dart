import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  int? _familyId() {
    final authState = context.read<AuthBloc>().state;
    return authState is Authenticated ? authState.user.familyId : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.background,
      body: BlocBuilder<FamilyTreeBloc, FamilyTreeState>(
        builder: (context, state) {
          final double topPadding = MediaQuery.of(context).padding.top;
          final double headerHeight = 195.0 + topPadding;

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
                top: headerHeight,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.background,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    image: DecorationImage(
                      image: AssetImage(
                        context.isDarkMode
                            ? 'assets/images/background_dark.png'
                            : 'assets/images/background.png',
                      ),
                      fit: BoxFit.cover,
                      opacity: context.isDarkMode ? 0.45 : 0.55,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: CustomScrollView(
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
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),

                        // ── Tìm kiếm Thành viên ──
                        SliverToBoxAdapter(
                          child:
                              _buildSearchBar(context, l10n.searchMembersHint),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 8)),

                        // ── Branches Section ──
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

                        // ── Members Grid ──
                        SliverToBoxAdapter(
                          child: AppSectionTitle(
                            title: l10n.memberTabLabel,
                          ),
                        ),

                        // Hiển thị danh sách thành viên được lọc theo tìm kiếm & chi tộc
                        Builder(
                          builder: (context) {
                            final filteredMembers = state.members.where((m) {
                              if (_selectedBranchId != null &&
                                  m.branchId != _selectedBranchId) {
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
                                childCount: filteredMembers.length,
                              ),
                            );
                          },
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, String hintText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 55),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.inter(fontSize: 13, color: context.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: context.textSecondary.withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 18,
            color: context.textSecondary,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    LucideIcons.x,
                    size: 16,
                    color: context.textSecondary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, FamilyTreeState state, double height) {
    final l10n = AppLocalizations.of(context)!;

    String familyName = l10n.familyTreeTitle;
    if (state is FamilyTreeLoaded) {
      if (state.family != null && state.family!.name.isNotEmpty) {
        familyName = state.family!.name;
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

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: context.appBarBg,
        image: DecorationImage(
          image: AssetImage(
            context.isDarkMode
                ? 'assets/images/background_appbar_dark.png'
                : 'assets/images/background_appbar_light.png',
          ),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: context.appBarOverlay),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Brand Logo / Avatar (Căn giữa - To hơn & Nét hơn)
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.accent, width: 2.0),
                      borderRadius: BorderRadius.circular(16),
                      color: context.background.withValues(alpha: 0.25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: () {
                        final familyLogo = (state is FamilyTreeLoaded)
                            ? state.family?.logoUrl
                            : null;
                        if (familyLogo != null && familyLogo.isNotEmpty) {
                          return AppNetworkImage(
                            url: familyLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (context) => Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(LucideIcons.gitBranch,
                                      color: context.accent, size: 36),
                            ),
                          );
                        }
                        return Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              LucideIcons.gitBranch,
                              color: context.accent,
                              size: 36),
                        );
                      }(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tên Gia Phả (Căn giữa)
                  Text(
                    familyName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Motto (Căn giữa)
                  Text(
                    l10n.spiritualMotto,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondary,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.users, color: context.accent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        l10n.memberCountBadge(state is FamilyTreeLoaded
                            ? state.members.length
                            : 0),
                        style: GoogleFonts.inter(
                          color: context.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(width: 1, height: 14, color: context.textSecondary.withValues(alpha: 0.5)),
                      const SizedBox(width: 20),
                      Icon(LucideIcons.gitBranch,
                          color: context.accent, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        l10n.branchCountLabel(state is FamilyTreeLoaded
                            ? state.branches.length
                            : 0),
                        style: GoogleFonts.inter(
                          color: context.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
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
}
