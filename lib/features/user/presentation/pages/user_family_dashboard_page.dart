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
          final double headerHeight = 155.0 + topPadding;

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
                      image: const AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                      opacity: context.isDarkMode ? 0.06 : 0.55,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: CustomScrollView(
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
                        const SliverToBoxAdapter(child: SizedBox(height: 50)),

                        // ── Branches Section ──
                        SliverToBoxAdapter(
                          child: AppSectionTitle(title: l10n.branchTabLabel),
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
                                          isSelected: false,
                                          onTap: null,
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
                          child: AppSectionTitle(title: l10n.memberTabLabel),
                        ),

                        // Hiển thị danh sách thành viên trực tiếp
                        if (state.members.isEmpty)
                          SliverToBoxAdapter(
                            child: AppEmptyState(
                              icon: LucideIcons.search,
                              message: l10n.noMemberFound,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 16),
                            ),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final member = state.members[index];
                                return MemberItemWidget(
                                  member: member,
                                  allMembers: state.members,
                                  showMenu: false,
                                );
                              },
                              childCount: state.members.length,
                            ),
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Brand Logo / Avatar (Căn giữa)
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
                      child: () {
                        final familyLogo = (state is FamilyTreeLoaded)
                            ? state.family?.logoUrl
                            : null;
                        if (familyLogo != null && familyLogo.isNotEmpty) {
                          return Image.network(
                            familyLogo,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(LucideIcons.gitBranch,
                                      color: context.accent, size: 24),
                            ),
                          );
                        }
                        return Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              LucideIcons.gitBranch,
                              color: context.accent,
                              size: 24),
                        );
                      }(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tên Gia Phả (Căn giữa)
                  Text(
                    familyName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.accent,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Motto (Căn giữa)
                  Text(
                    l10n.spiritualMotto,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: context.accent.withValues(alpha: 0.9),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
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
}
