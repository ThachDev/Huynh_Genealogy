import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entity/member_entity.dart';
import '../bloc/tree/tree_bloc.dart';
import '../widgets/branch_card.dart';
import 'tree_view_page.dart';

class FamilyDashboardPage extends StatefulWidget {
  const FamilyDashboardPage({super.key});

  @override
  State<FamilyDashboardPage> createState() => _FamilyDashboardPageState();
}

class _FamilyDashboardPageState extends State<FamilyDashboardPage> {
  int? _selectedBranchId;
  final TextEditingController _searchController = TextEditingController();
  String _selectedGender = 'Tất cả';

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
              _buildHeader(context),

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
                          LucideIcons.alertCircle,
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
                // ── Today's Events Banner ──
                _buildEventsBanner(),

                // ── Stats Section ──
                SliverToBoxAdapter(
                  child: _buildStats(
                    state.members.length,
                    state.branches.length,
                  ),
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
                          child: BranchCard(
                            branch: branch,
                            isSelected: _selectedBranchId == branch.id,
                            onTap: () {
                              setState(() => _selectedBranchId = branch.id);
                              context.read<TreeBloc>().add(
                                FilterByBranchEvent(branch.id),
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
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TreeViewPage()),
          );
        },
        backgroundColor: AppColors.crimson,
        elevation: 6,
        icon: const Icon(LucideIcons.gitBranch, color: Colors.white),
        label: Text(
          'XEM SƠ ĐỒ',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
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
                                const Icon(LucideIcons.gitBranch, color: AppColors.gold, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GIA PHẢ HỌ HUỲNH',
                            style: GoogleFonts.beVietnamPro(
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
                  const Spacer(),
                  // Search and Filter
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Tìm tên, chi tộc, năm sinh...',
                                  hintStyle: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: const Icon(
                                    LucideIcons.search,
                                    color: AppColors.gold,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withValues(
                                    alpha: 0.24,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: GoogleFonts.inter(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Filter Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.24),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedGender,
                                underline: const SizedBox(),
                                icon: const Icon(
                                  LucideIcons.filter,
                                  color: AppColors.gold,
                                ),
                                dropdownColor: AppColors.wood,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                items: ['Tất cả', 'Nam', 'Nữ'].map((
                                  String val,
                                ) {
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
                        const SizedBox(height: 12),
                        // Add Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              LucideIcons.plusCircle,
                              size: 20,
                            ),
                            label: Text(
                              'THÊM THÀNH VIÊN',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.crimson,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shadowColor: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsBanner() {
    // Fake current events for demonstration
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.crimson.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.gold, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.sparkles,
                  color: AppColors.crimson,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'SỰ KIỆN HÔM NAY',
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    color: AppColors.crimson,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.flame,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Giỗ cụ Huỳnh Công Minh',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    backgroundColor: AppColors.crimson,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Đốt Nhang',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(int memberCount, int branchCount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.wood,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Thành viên', memberCount.toString(), LucideIcons.users),
          Container(width: 1, height: 30, color: Colors.white24),
          _statItem('Chi tộc', branchCount.toString(), LucideIcons.gitBranch),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
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
                ? const Icon(
                    LucideIcons.user,
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
        trailing: const Icon(LucideIcons.chevronRight, color: AppColors.gold),
        onTap: () {
          // Navigate to detail
        },
      ),
    );
  }
}
