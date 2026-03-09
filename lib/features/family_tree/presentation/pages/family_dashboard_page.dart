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
                  const Spacer(),
                  // Search and Filter
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Search and Filter Premium Unified
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Tìm kiếm người thân...',
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.white38,
                                      fontSize: 13,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: AppColors.gold,
                                      size: 22,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1.2,
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppColors.gold.withValues(alpha: 0.4),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(canvasColor: AppColors.wood),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedGender,
                                      icon: const Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.gold,
                                          size: 20,
                                        ),
                                      ),
                                      dropdownColor: const Color(0xFF3E2723),
                                      borderRadius: BorderRadius.circular(15),
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      items:
                                          [
                                            ['Tất cả', Icons.all_inclusive],
                                            ['Nam', Icons.male_rounded],
                                            ['Nữ', Icons.female_rounded],
                                          ].map((item) {
                                            final label = item[0] as String;
                                            final icon = item[1] as IconData;
                                            return DropdownMenuItem<String>(
                                              value: label,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    icon,
                                                    size: 16,
                                                    color: AppColors.gold
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(label),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() => _selectedGender = val);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Add Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_circle_outline,
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
                  Icons.auto_awesome,
                  color: AppColors.crimson,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'SỰ KIỆN HÔM NAY',
                  style: GoogleFonts.playfairDisplay(
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
                        Icons.local_fire_department,
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
          _statItem('Thành viên', memberCount.toString(), Icons.people),
          Container(width: 1, height: 30, color: Colors.white24),
          _statItem('Chi tộc', branchCount.toString(), Icons.park),
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
          style: GoogleFonts.playfairDisplay(
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
            style: GoogleFonts.playfairDisplay(
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
