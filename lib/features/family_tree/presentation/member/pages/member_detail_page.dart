import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/utils/date_formatter.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';

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
        final allMembers = state is TreeLoaded ? state.allMembers : <MemberEntity>[];
        final memberMap = {for (final m in allMembers) m.id: m};

        return Scaffold(
          backgroundColor: AppColors.parchment,
          body: CustomScrollView(
            slivers: [
              // ── Header Modal with Ancient Clouds ──
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
                      icon: const Icon(Icons.arrow_back, color: AppColors.crimson),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
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
                          border: Border.all(color: AppColors.gold, width: 4),
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
                          backgroundImage: widget.member.avatarUrl != null
                              ? NetworkImage(widget.member.avatarUrl!)
                              : null,
                          child: widget.member.avatarUrl == null
                              ? Center(
                                  child: Icon(
                                    widget.member.gender == Gender.female
                                        ? Icons.person_2_rounded
                                        : Icons.person_rounded,
                                    size: 70,
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        widget.member.fullName.toUpperCase(),
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
                            'Đời thứ ${widget.member.generation ?? "?"}',
                            AppColors.gold,
                          ),
                          const SizedBox(width: 8),
                          _buildBadge(
                            widget.member.isAlive ? "CÒN SỐNG" : "ĐÃ MẤT",
                            widget.member.isAlive
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
                        DateFormatter.formatForDisplay(widget.member.dateOfBirth) ??
                            'Chưa rõ',
                      ),
                      if (!widget.member.isAlive)
                        _buildInfoRow(
                          Icons.event_note,
                          'Ngày mất',
                          DateFormatter.formatForDisplay(
                                widget.member.dateOfDeath,
                              ) ??
                              'Chưa rõ',
                        ),
                      _buildInfoRow(
                        Icons.place,
                        'Nơi sinh',
                        widget.member.placeOfBirth ?? 'Chưa rõ',
                      ),
                      _buildInfoRow(
                        Icons.park,
                        'Chi tộc',
                        widget.member.branchName ?? 'Họ Huỳnh',
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildInfoSection('QUAN HỆ GIA ĐÌNH', [
                      _buildRelationshipRow(
                        context,
                        'Cha/Mẹ',
                        widget.member.parentId,
                        memberMap,
                      ),
                      _buildRelationshipRow(
                        context,
                        'Vợ/Chồng',
                        widget.member.spouseId,
                        memberMap,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildBioSection(),
                  ]),
                ),
              ),
            ],
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
    Map<int, MemberEntity> memberMap,
  ) {
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
            Text(
              'Không rõ',
              style: GoogleFonts.inter(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            )
          else
            TextButton(
              onPressed: () {
                // Điều hướng sang trang chi tiết của người thân
                context.pushReplacement('/members/${relatedMember.id}', extra: relatedMember);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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


  Widget _buildBioSection() {
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
            widget.member.notes ??
                'Chưa có thông tin tiểu sử cho thành viên này.',
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
}
