import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/domain/entity/member_entity.dart';

class MemberItemWidget extends StatelessWidget {
  final MemberEntity member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MemberItemWidget({
    super.key,
    required this.member,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String genderText = member.gender == Gender.male ? 'Nam' : 'Nữ';
    final String aliveText = member.isAlive ? 'Còn sống' : 'Đã mất';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: member.gender == Gender.male
                ? Colors.blue.shade50
                : Colors.pink.shade50,
            backgroundImage: member.avatarUrl != null
                ? NetworkImage(member.avatarUrl!)
                : null,
            child: member.avatarUrl == null
                ? Icon(
                    member.gender == Gender.male
                        ? LucideIcons.user
                        : LucideIcons.user2,
                    color: member.gender == Gender.male
                        ? Colors.blue
                        : Colors.pink,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Đời thứ ${member.generation ?? "?"}',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: member.isAlive ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        aliveText,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: member.isAlive ? Colors.green : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      genderText,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (member.branchName != null &&
                    member.branchName!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.gitBranch, size: 12, color: AppColors.wood),
                      const SizedBox(width: 4),
                      Text(
                        'Chi tộc: ${member.branchName}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.wood,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical, color: AppColors.textSecondary, size: 20),
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(LucideIcons.edit, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Chỉnh sửa',
                      style: GoogleFonts.beVietnamPro(fontSize: 13),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(LucideIcons.trash2, color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Xóa',
                      style: GoogleFonts.beVietnamPro(fontSize: 13, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
