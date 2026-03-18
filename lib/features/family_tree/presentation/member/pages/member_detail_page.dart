import 'package:app_family_tree/core/di/injection_container.dart' as di;
import 'package:app_family_tree/core/utils/date_formatter.dart';
import 'package:app_family_tree/core/utils/member_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/app/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/widgets/add_member_dialog.dart';

class MemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const MemberDetailPage({super.key, required this.member});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TreeBloc, TreeState>(
      builder: (context, state) {
        // Lấy danh sách thành viên để tìm tên người thân
        final allMembers = state is TreeLoaded
            ? state.allMembers
            : <MemberEntity>[];
        final memberMap = {for (final m in allMembers) m.id: m};

        // Luôn lấy dữ liệu mới nhất từ Bloc nếu có (đề phòng vừa sửa xong)
        final member = memberMap[widget.member.id] ?? widget.member;

        return Scaffold(
          backgroundColor: AppColors.parchment,
          body: BlocProvider(
            create: (context) => di.sl<MemberFormBloc>(),
            child: BlocListener<MemberFormBloc, MemberFormState>(
              listener: (context, state) {
                if (state is MemberFormSuccess) {
                  context.read<TreeBloc>().add(LoadTreeEvent(force: true));
                  if (state.isDeleted && context.mounted) {
                    context.pop();
                  }
                } else if (state is MemberFormError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: CustomScrollView(
                slivers: [
                  // ── Header Modal ──
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: AppColors.parchment,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.crimson,
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit_note_rounded,
                              color: AppColors.crimson,
                            ),
                            onPressed: () {
                              final treeBloc = context.read<TreeBloc>();
                              showDialog(
                                context: context,
                                barrierColor: Colors.black.withValues(
                                  alpha: 0.6,
                                ),
                                builder: (ctx) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider<MemberFormBloc>(
                                      create: (_) => di.sl<MemberFormBloc>(),
                                    ),
                                    BlocProvider.value(value: treeBloc),
                                  ],
                                  child: AddMemberDialog(memberToEdit: member),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  // ── Avatar Overlay and Basic Info ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          // Large Avatar
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.gold,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 56,
                              backgroundColor: AppColors.parchment,
                              backgroundImage: member.fullAvatarUrl != null
                                  ? NetworkImage(member.fullAvatarUrl!)
                                  : null,
                              child: member.fullAvatarUrl == null
                                  ? Center(
                                      child: Icon(
                                        member.gender == Gender.female
                                            ? Icons.person_2_rounded
                                            : Icons.person_rounded,
                                        size: 70,
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.5),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            member.fullName.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.crimson,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildBadge(
                                'Đời thứ ${member.generation ?? "?"}',
                                AppColors.gold,
                              ),
                              const SizedBox(width: 8),
                              _buildBadge(
                                member.isAlive ? "CÒN SỐNG" : "ĐÃ MẤT",
                                member.isAlive
                                    ? Colors.green
                                    : AppColors.textSecondary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // ── Detailed Information ──
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildInfoSection('THÔNG TIN CÁ NHÂN', [
                          _buildInfoRow(
                            Icons.cake,
                            'Ngày sinh',
                            DateFormatter.formatForDisplay(
                                  member.dateOfBirth,
                                ) ??
                                'Chưa rõ',
                          ),
                          if (!member.isAlive)
                            _buildInfoRow(
                              Icons.event_note,
                              'Ngày mất',
                              DateFormatter.formatForDisplay(
                                    member.dateOfDeath,
                                  ) ??
                                  'Chưa rõ',
                            ),
                          _buildInfoRow(
                            Icons.place,
                            'Nơi sinh',
                            member.placeOfBirth ?? 'Chưa rõ',
                          ),
                          _buildInfoRow(
                            Icons.park,
                            'Chi tộc',
                            member.branchName ?? 'Họ Huỳnh',
                          ),
                        ]),
                        const SizedBox(height: 24),
                        _buildInfoSection('QUAN HỆ GIA ĐÌNH', [
                          _buildRelationshipRow(
                            context,
                            'Cha/Mẹ',
                            member.parentId,
                            memberMap,
                            onAdd: () {
                              _showAddMemberDialog(
                                context,
                                initialBranchId: member.branchId,
                              );
                            },
                          ),
                          _buildRelationshipRow(
                            context,
                            'Vợ/Chồng',
                            member.spouseId,
                            memberMap,
                            onAdd: () {
                              _showAddMemberDialog(
                                context,
                                initialSpouseId: member.id,
                                initialBranchId: member.branchId,
                              );
                            },
                          ),
                        ]),
                        const SizedBox(height: 24),
                        _buildChildrenSection(context, member, allMembers),
                        const SizedBox(height: 24),
                        _buildBioSection(member),
                        const SizedBox(height: 48),
                        _buildDeleteButton(context, member),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gold, thickness: 0.5),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipRow(
    BuildContext context,
    String label,
    int? memberId,
    Map<int, MemberEntity> memberMap, {
    VoidCallback? onAdd,
  }) {
    final relatedMember = memberId != null ? memberMap[memberId] : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.people_outline, size: 18, color: AppColors.gold),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (memberId == null || relatedMember == null)
            onAdd != null
                ? IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.crimson,
                      size: 20,
                    ),
                    onPressed: onAdd,
                  )
                : Text(
                    'Không rõ',
                    style: GoogleFonts.inter(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  )
          else
            TextButton(
              onPressed: () {
                context.push(
                  '/members/${relatedMember.id}',
                  extra: relatedMember,
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                backgroundColor: AppColors.gold.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                relatedMember.fullName,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChildrenSection(
    BuildContext context,
    MemberEntity member,
    List<MemberEntity> allMembers,
  ) {
    final children = allMembers.where((m) => m.parentId == member.id).toList();

    return _buildInfoSection('CON CÁI', [
      if (children.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Text(
                'Chưa có thông tin con cái',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.crimson,
                  size: 20,
                ),
                onPressed: () => _showAddMemberDialog(
                  context,
                  initialParentId: member.id,
                  initialBranchId: member.branchId,
                ),
              ),
            ],
          ),
        )
      else
        ...children.map(
          (child) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Icon(
                  child.gender == Gender.female
                      ? Icons.person_2_outlined
                      : Icons.person_outlined,
                  size: 18,
                  color: AppColors.gold,
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    context.push('/members/${child.id}', extra: child);
                  },
                  child: Text(
                    child.fullName,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      if (children.isNotEmpty)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _showAddMemberDialog(
              context,
              initialParentId: member.id,
              initialBranchId: member.branchId,
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Thêm con'),
            style: TextButton.styleFrom(foregroundColor: AppColors.crimson),
          ),
        ),
    ]);
  }

  void _showAddMemberDialog(
    BuildContext context, {
    int? initialParentId,
    int? initialSpouseId,
    int? initialBranchId,
  }) {
    final treeBloc = context.read<TreeBloc>();
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider<MemberFormBloc>(create: (_) => di.sl<MemberFormBloc>()),
          BlocProvider.value(value: treeBloc),
        ],
        child: AddMemberDialog(
          initialParentId: initialParentId,
          initialSpouseId: initialSpouseId,
          initialBranchId: initialBranchId,
        ),
      ),
    );
  }

  Widget _buildBioSection(MemberEntity member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_edu, color: AppColors.gold, size: 18),
            const SizedBox(width: 8),
            Text(
              'TIỂU SỬ & GHI CHÚ',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.gold, thickness: 0.5),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Text(
            member.notes ?? 'Chưa có thông tin tiểu sử cho thành viên này.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              height: 1.6,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context, MemberEntity member) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () async {
              final confirm = await _showDeleteConfirmDialog(
                context,
                member.fullName,
              );
              if (confirm == true && context.mounted) {
                context.read<MemberFormBloc>().add(
                  DeleteMemberFormEvent(member.id),
                );
              }
            },
            icon: const Icon(Icons.delete_outline, color: AppColors.crimson),
            label: Text(
              'XÓA THÀNH VIÊN',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: AppColors.crimson,
                letterSpacing: 1.2,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.crimson, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        );
      },
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
