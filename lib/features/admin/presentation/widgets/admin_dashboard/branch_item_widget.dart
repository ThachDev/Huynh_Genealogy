import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/domain/entity/branch_entity.dart';

class BranchItemWidget extends StatelessWidget {
  final BranchEntity branch;
  final int memberCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BranchItemWidget({
    super.key,
    required this.branch,
    required this.memberCount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.wood.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.gitBranch,
                color: AppColors.wood, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (branch.founderName != null &&
                    branch.founderName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Đời tổ/Sáng lập: ${branch.founderName}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(LucideIcons.users,
                        size: 12, color: Colors.blueGrey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      '$memberCount thành viên',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                  ],
                ),
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
