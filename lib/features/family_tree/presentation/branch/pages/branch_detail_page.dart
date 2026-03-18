import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app_family_tree/app/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/widgets/add_member_dialog.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/bloc/branch_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/branch/widgets/add_branch_dialog.dart';

class BranchDetailPage extends StatefulWidget {
  final BranchEntity branch;

  const BranchDetailPage({super.key, required this.branch});

  @override
  State<BranchDetailPage> createState() => _BranchDetailPageState();
}

class _BranchDetailPageState extends State<BranchDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreeBloc, TreeState>(
      builder: (context, state) {
        final stateBranch = state is TreeLoaded
            ? state.branches.firstWhere(
                (b) => b.id == widget.branch.id,
                orElse: () => widget.branch,
              )
            : widget.branch;

        final members = state is TreeLoaded
            ? state.allMembers
                  .where((m) => m.branchId == stateBranch.id)
                  .toList()
            : <MemberEntity>[];

        return Scaffold(
          backgroundColor: AppColors.parchment,
          appBar: _buildAppBar(context, stateBranch),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildBranchInfo(stateBranch),
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
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.crimson,
                        size: 20,
                      ),
                      onPressed: () {
                        final treeBloc = context.read<TreeBloc>();
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withValues(alpha: 0.6),
                          builder: (ctx) => MultiBlocProvider(
                            providers: [
                              BlocProvider<MemberFormBloc>(
                                create: (_) => di.sl<MemberFormBloc>(),
                              ),
                              BlocProvider.value(value: treeBloc),
                            ],
                            child: AddMemberDialog(
                              initialBranchId: widget.branch.id,
                            ),
                          ),
                        );
                      },
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
                            child: _buildSlidableMemberTile(context, member),
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

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    BranchEntity stateBranch,
  ) {
    return AppBar(
      backgroundColor: AppColors.wood,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.gold,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'branch_${widget.branch.id}',
            child: const Icon(
              Icons.park_rounded,
              size: 24,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            stateBranch.name.toUpperCase(),
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
              fontSize: 18,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_note_rounded, color: AppColors.gold),
          onPressed: () {
            final treeBloc = context.read<TreeBloc>();
            showDialog(
              context: context,
              barrierColor: Colors.black.withValues(alpha: 0.6),
              builder: (ctx) => MultiBlocProvider(
                providers: [
                  BlocProvider<BranchFormBloc>(
                    create: (_) => di.sl<BranchFormBloc>(),
                  ),
                  BlocProvider.value(value: treeBloc),
                ],
                child: AddBranchDialog(branchToEdit: stateBranch),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
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

  Widget _buildBranchInfo(BranchEntity branch) {
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

  Widget _buildSlidableMemberTile(BuildContext context, MemberEntity m) {
    return BlocProvider(
      create: (context) => di.sl<MemberFormBloc>(),
      child: BlocListener<MemberFormBloc, MemberFormState>(
        listener: (context, state) {
          if (state is MemberFormSuccess && state.isDeleted) {
            context.read<TreeBloc>().add(LoadTreeEvent(force: true));
          } else if (state is MemberFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Slidable(
              key: Key('branch_member_${m.id}'),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.22,
                children: [
                  CustomSlidableAction(
                    onPressed: (_) async {
                      final confirm = await _showDeleteConfirmDialog(
                        context,
                        m.fullName,
                      );
                      if (confirm == true && context.mounted) {
                        context.read<MemberFormBloc>().add(
                          DeleteMemberFormEvent(m.id),
                        );
                      }
                    },
                    backgroundColor: AppColors.parchment,
                    foregroundColor: Colors.white,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.delete_outline, size: 28),
                    ),
                  ),
                ],
              ),
              child: _buildMemberTile(context, m),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, MemberEntity m) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(right: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.5),
          ),
          child: CircleAvatar(
            backgroundColor: m.gender == Gender.male
                ? AppColors.nodeMale
                : AppColors.nodeFemale,
            radius: 20,
            backgroundImage: m.fullAvatarUrl != null
                ? NetworkImage(m.fullAvatarUrl!)
                : null,
            child: m.fullAvatarUrl == null
                ? Icon(
                    m.gender == Gender.male ? Icons.man : Icons.woman,
                    color: AppColors.crimson,
                    size: 20,
                  )
                : null,
          ),
        ),
        title: Text(
          m.fullName,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
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

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.parchment,
        title: Text(
          'Xác nhận xóa',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: AppColors.crimson,
          ),
        ),
        content: Text(
          'Bạn có chắc muốn xóa thành viên $name khỏi gia phả không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.crimson),
            child: const Text(
              'Xóa ngay',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
