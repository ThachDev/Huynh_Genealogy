import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/application/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/widgets/branch_card.dart';
import 'package:app_family_tree/features/family_tree/domain/entity/member_entity.dart';

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
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: BlocBuilder<TreeBloc, TreeState>(
        builder: (context, state) {
          return CustomScrollView(
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

              if (state is TreeLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.crimson),
                  ),
                ),

              if (state is TreeError)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.crimson,
                        ),
                        const SizedBox(height: 16),
                        Text(state.message, style: GoogleFonts.inter()),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<TreeBloc>().add(LoadTreeEvent()),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                ),

              if (state is TreeLoaded) ...[
                // ── Search & Filter ──
                // SliverToBoxAdapter(child: _buildSearchAndFilter()),
                // ── Branches Section ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _buildSectionTitle('Chi Tộc', 'Xem tất cả'),
                  ),
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
                        final isSelected = state.filterBranchId == branch.id;
                        return SizedBox(
                          width: 350,
                          child: BranchCard(
                            branch: branch,
                            isSelected: isSelected,
                            onTap: () {
                              // Toggle filter nhanh chóng thông qua Bloc
                              final newId = isSelected ? null : branch.id;
                              context.read<TreeBloc>().add(
                                FilterByBranchEvent(newId),
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
                  child: _buildSectionTitle(
                    state.filterBranchId == null
                        ? 'Thành Viên'
                        : 'Thành Viên • ${state.branches.where((b) => b.id == state.filterBranchId).first.name}',
                    state.filterBranchId != null ? 'Tất cả' : 'Xem tất cả',
                    onAction: state.filterBranchId != null
                        ? () {
                            context.read<TreeBloc>().add(
                              FilterByBranchEvent(null),
                            );
                          }
                        : null,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: 90,
                          mainAxisSpacing: 10,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final member = state.members[index];
                      return _buildMemberCard(member);
                    }, childCount: state.members.length),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int memberCount, int branchCount) {
    return SliverAppBar(
      expandedHeight: 190,
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
              child: Container(color: Colors.black.withValues(alpha: 0.3)),
            ),
            // Content
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  // Logo and Title
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
                            'GIA PHẢ HỌ HUỲNH',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'CỘI NGUỒN TÂM LINH • VẠN ĐẠI TRƯỜNG TỒN',
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
                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem(
                          'Thành viên',
                          memberCount.toString(),
                          Icons.people_alt_rounded,
                          light: true,
                        ),
                        Container(width: 1, height: 30, color: Colors.white24),
                        _statItem(
                          'Chi tộc',
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
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberEntity m) {
    return Card(
      elevation: 0,
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
            backgroundImage: m.avatarUrl != null
                ? NetworkImage(m.avatarUrl!)
                : null,
            child: m.avatarUrl == null
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
          'Đời ${m.generation ?? "?"} • ${m.branchName ?? "Họ Huỳnh"} • ${m.isAlive ? "Còn sống" : "Đã mất"}',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
        onTap: () {
          // Navigate to detail
        },
      ),
    );
  }
}
