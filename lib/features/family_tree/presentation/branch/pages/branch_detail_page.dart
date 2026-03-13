import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:go_router/go_router.dart';

class BranchDetailPage extends StatelessWidget {
  final BranchEntity branch;

  const BranchDetailPage({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreeBloc, TreeState>(
      builder: (context, state) {
        final members = state is TreeLoaded
            ? state.allMembers.where((m) => m.branchId == branch.id).toList()
            : <MemberEntity>[];

        return Scaffold(
          backgroundColor: AppColors.parchment,
          appBar: _buildAppBar(context),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildBranchInfo(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Container(width: 4, height: 18, color: AppColors.crimson),
                    const SizedBox(width: 10),
                    Text(
                      'DANH SÁCH THÀNH VIÊN',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${members.length} người',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (members.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Center(
                    child: Text(
                      'Chưa có thành viên trong chi tộc này',
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 30.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildMemberTile(context, member),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.wood,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.gold, size: 20),
        onPressed: () => context.pop(),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'branch_${branch.id}',
            child: const Icon(
              Icons.park_rounded,
              size: 24,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            branch.name.toUpperCase(),
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/wood_dragon.png',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.wood),
          ),
          Container(color: Colors.black.withValues(alpha: 0.3)),
        ],
      ),
    );
  }

  Widget _buildBranchInfo() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              Icons.person,
              'Người sáng lập',
              branch.founderName ?? 'Chưa rõ',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.calendar_today,
              'Năm thành lập',
              branch.foundingYear?.toString() ?? 'Chưa rõ',
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.location_on,
              'Vùng miền',
              branch.region ?? 'Chưa rõ',
            ),
            const Divider(height: 24),
            Text(
              'Mô tả',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              branch.description ?? 'Chưa có mô tả cho chi tộc này.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.crimson),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMemberTile(BuildContext context, MemberEntity m) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: m.gender == Gender.male
              ? AppColors.nodeMale
              : AppColors.nodeFemale,
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
        title: Text(
          m.fullName,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          'Đời ${m.generation ?? "?"} • ${m.isAlive ? "Còn sống" : "Đã mất"}',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gold),
        onTap: () => context.push('/members/${m.id}', extra: m),
      ),
    );
  }
}
