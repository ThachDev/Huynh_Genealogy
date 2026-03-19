import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/widgets/branch_card.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/widgets/dashboard_skeleton.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/widgets/tree_background_painter.dart';
import 'package:go_router/go_router.dart';
import 'package:resources/resources.dart';

class FamilyDashboardPage extends StatefulWidget {
  const FamilyDashboardPage({super.key});

  @override
  State<FamilyDashboardPage> createState() => _FamilyDashboardPageState();
}

class _FamilyDashboardPageState extends State<FamilyDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<TreeBloc>().add(LoadTreeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Stack(
        children: [
          // Elegant East-Asian Background Painter
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          BlocBuilder<TreeBloc, TreeState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── Wooden Header with Dragon Patterns ──
                  if (state is TreeLoaded)
                    _buildHeader(
                      context,
                      state.members.length,
                      state.branches.length,
                    )
                  else
                    _buildHeader(context, 0, 0),

                  if (state is TreeLoading || state is TreeInitial)
                    const SliverDashboardSkeleton(),

                  if (state is TreeError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 60,
                                color: AppColors.crimson,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 160,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () => context.read<TreeBloc>().add(
                                    LoadTreeEvent(),
                                  ),
                                  child: Text(l10n.retry),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  if (state is TreeLoaded) ...[
                    // ── Branches Section ──
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _buildSectionTitle(
                          l10n.branch,
                          l10n.viewAll,
                          onAction: () => context.push('/branches'),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 140,
                        child: state.branches.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 40,
                                      color: AppColors.gold.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.noBranchData,
                                      style: GoogleFonts.inter(
                                        color: AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : state.branches.length == 1
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    child: BranchCard(
                                      branch: state.branches.first,
                                      isSelected:
                                          state.filterBranchId ==
                                          state.branches.first.id,
                                      onTap: () {
                                        final isSelected =
                                            state.filterBranchId ==
                                            state.branches.first.id;
                                        final newId = isSelected
                                            ? null
                                            : state.branches.first.id;
                                        context.read<TreeBloc>().add(
                                          FilterByBranchEvent(newId),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                itemCount: state.branches.length,
                                itemBuilder: (_, index) {
                                  final branch = state.branches[index];
                                  final isSelected =
                                      state.filterBranchId == branch.id;
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 400),
                                    child: SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.85,
                                          child: BranchCard(
                                            branch: branch,
                                            isSelected: isSelected,
                                            onTap: () {
                                              final newId = isSelected
                                                  ? null
                                                  : branch.id;
                                              context.read<TreeBloc>().add(
                                                FilterByBranchEvent(newId),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),

                    // ── Members Grid ──
                    SliverToBoxAdapter(
                      child: _buildSectionTitle(
                        state.filterBranchId == null
                            ? l10n.member
                            : '${l10n.member} • ${state.branches.where((b) => b.id == state.filterBranchId).first.name}',
                        state.filterBranchId != null
                            ? l10n.viewAll
                            : l10n.viewAll,
                        onAction: () {
                          if (state.filterBranchId != null) {
                            context.read<TreeBloc>().add(
                              FilterByBranchEvent(null),
                            );
                          } else {
                            context.push('/members');
                          }
                        },
                      ),
                    ),
                    if (state.members.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.group_off_rounded,
                                  size: 48,
                                  color: AppColors.gold.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noMemberData,
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final member = state.members[index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _buildMemberCard(
                                      member,
                                      l10n,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }, childCount: state.members.length),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int memberCount, int branchCount) {
    final l10n = S.of(context);
    return SliverAppBar(
      expandedHeight: 190,
      pinned: false,
      backgroundColor: AppColors.wood,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/wood_dragon.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: AppColors.wood),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gold, width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.parchment.withValues(alpha: 0.1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.park,
                                  color: AppColors.gold,
                                  size: 40,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.appTitle.toUpperCase(),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            l10n.motto,
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem(
                          l10n.member,
                          memberCount.toString(),
                          Icons.people_alt_rounded,
                          light: true,
                        ),
                        Container(width: 1, height: 30, color: Colors.white24),
                        _statItem(
                          l10n.branch,
                          branchCount.toString(),
                          Icons.park_rounded,
                          light: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(
    String label,
    String value,
    IconData icon, {
    bool light = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: light ? AppColors.gold : AppColors.crimson,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: light ? Colors.white70 : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: light ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    String description, {
    VoidCallback? onAction,
    VoidCallback? onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(width: 4, height: 18, color: AppColors.crimson),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
            ),
          ),
          GestureDetector(
            onTap: onAction ?? () {},
            child: Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),
          ),
          if (onAdd != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.crimson,
                size: 20,
              ),
              onPressed: onAdd,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberEntity m, S l10n) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        right: 8,
      ), // Thêm margin bên phải để tạo khoảng cách với nút xóa
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.5),
          ),
          child: CircleAvatar(
            backgroundColor: m.gender == Gender.male
                ? AppColors.nodeMale
                : AppColors.nodeFemale,
            radius: 24,
            backgroundImage: m.fullAvatarUrl != null
                ? NetworkImage(m.fullAvatarUrl!)
                : null,
            child: m.fullAvatarUrl == null
                ? Icon(
                    m.gender == Gender.male ? Icons.man : Icons.woman,
                    color: AppColors.crimson,
                  )
                : null,
          ),
        ),
        title: Text(
          m.fullName,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${l10n.generation} ${m.generation ?? "?"} • ${m.branchName ?? "Họ Huỳnh"} • ${m.isAlive ? l10n.stillAlive : l10n.deceased}',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
        onTap: () {
          context.push('/members/${m.id}', extra: m);
        },
      ),
    );
  }

}
