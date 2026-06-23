import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entity/member_entity.dart';

class MemberDetailPage extends StatefulWidget {
  final MemberEntity member;

  const MemberDetailPage({super.key, required this.member});

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  int _spiritualCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        slivers: [
          // ── Header Modal with Ancient Clouds ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.crimson,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/clouds.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: AppColors.crimson),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.5),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Avatar Overlay and Basic Info ──
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -50),
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
                          ? const Icon(
                              LucideIcons.user,
                              size: 60,
                              color: AppColors.crimson,
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
                  // Spiritual Interaction
                  _buildSpiritualButton(),
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
                    LucideIcons.cake,
                    'Ngày sinh',
                    DateFormatter.formatForDisplay(widget.member.dateOfBirth) ??
                        'Chưa rõ',
                  ),
                  if (!widget.member.isAlive)
                    _buildInfoRow(
                      LucideIcons.calendar,
                      'Ngày mất',
                      DateFormatter.formatForDisplay(
                            widget.member.dateOfDeath,
                          ) ??
                          'Chưa rõ',
                    ),
                  _buildInfoRow(
                    LucideIcons.mapPin,
                    'Nơi sinh',
                    widget.member.placeOfBirth ?? 'Chưa rõ',
                  ),
                  _buildInfoRow(
                    LucideIcons.gitBranch,
                    'Chi tộc',
                    widget.member.branchName ?? 'Họ Huỳnh',
                  ),
                ]),
                const SizedBox(height: 24),
                _buildInfoSection('QUAN HỆ GIA ĐÌNH', [
                  _buildRelationshipRow('Cha/Mẹ', widget.member.parentId),
                  _buildRelationshipRow('Vợ/Chồng', widget.member.spouseId),
                ]),
                const SizedBox(height: 24),
                _buildBioSection(),
              ]),
            ),
          ),
        ],
      ),
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

  Widget _buildSpiritualButton() {
    final bool isDeceased = !widget.member.isAlive;
    return ElevatedButton.icon(
      onPressed: () {
        setState(() => _spiritualCount++);
        // Show lottie effect here if available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isDeceased
                  ? 'Bạn đã thắp một nén nhang thành tâm.'
                  : 'Bạn đã gửi một lời chúc mừng.',
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: AppColors.crimson,
          ),
        );
      },
      icon: Icon(
        isDeceased ? LucideIcons.flame : LucideIcons.gift,
      ),
      label: Text(
        isDeceased
            ? 'ĐỐT NHANG ($_spiritualCount)'
            : 'CHÚC MỪNG ($_spiritualCount)',
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.crimson,
        side: const BorderSide(color: AppColors.gold, width: 2),
        elevation: 8,
        shadowColor: AppColors.gold.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.info, color: AppColors.gold, size: 18),
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

  Widget _buildRelationshipRow(String label, int? memberId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(LucideIcons.users, size: 18, color: AppColors.gold),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (memberId == null)
            Text(
              'Không rõ',
              style: GoogleFonts.inter(fontStyle: FontStyle.italic),
            )
          else
            TextButton(
              onPressed: () {},
              child: Text(
                'Thành viên #$memberId',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
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
            const Icon(LucideIcons.scroll, color: AppColors.gold, size: 18),
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
