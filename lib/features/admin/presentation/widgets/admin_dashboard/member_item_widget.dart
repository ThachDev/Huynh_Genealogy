import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/domain/entity/member_entity.dart';

class MemberItemWidget extends StatelessWidget {
  final MemberEntity member;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const MemberItemWidget({
    super.key,
    required this.member,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String aliveText = member.isAlive ? 'Còn sống' : 'Đã mất';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.wood.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: member.gender == Gender.male
                    ? AppColors.nodeMale
                    : AppColors.nodeFemale,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with Gender Badge overlay
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: member.gender == Gender.male
                          ? AppColors.nodeMale.withValues(alpha: 0.5)
                          : AppColors.nodeFemale.withValues(alpha: 0.5),
                      backgroundImage: member.avatarUrl != null
                          ? NetworkImage(member.avatarUrl!)
                          : null,
                      child: member.avatarUrl == null
                          ? Icon(
                              member.gender == Gender.male
                                  ? LucideIcons.user
                                  : LucideIcons.user2,
                              color: AppColors.textSecondary,
                              size: 24,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: member.gender == Gender.male
                            ? AppColors.nodeMale
                            : AppColors.nodeFemale,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Icon(
                        member.gender == Gender.male
                            ? Icons.male
                            : Icons.female,
                        color: member.gender == Gender.male
                            ? AppColors.crimson
                            : AppColors.gold,
                        size: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      member.fullName,
                      style: GoogleFonts.beVietnamPro(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Badges row
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Generation Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.gitCommit,
                                size: 10,
                                color: AppColors.gold,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Đời thứ ${member.generation ?? "?"}',
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.gold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status Badge (Alive / Deceased)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: member.isAlive
                                ? AppColors.crimson.withValues(alpha: 0.06)
                                : AppColors.nodeDeceased
                                    .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: member.isAlive
                                  ? AppColors.crimson.withValues(alpha: 0.15)
                                  : AppColors.nodeDeceased
                                      .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                member.isAlive
                                    ? LucideIcons.heart
                                    : LucideIcons.heartCrack,
                                size: 10,
                                color: member.isAlive
                                    ? AppColors.crimson
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                aliveText,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: member.isAlive
                                      ? AppColors.crimson
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (member.branchName != null &&
                        member.branchName!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      // Branch Badge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.gitBranch,
                            size: 12,
                            color:
                                AppColors.textSecondary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Chi tộc: ${member.branchName}',
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Dropdown Actions Button
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.white,
                elevation: 4,
                offset: const Offset(18, 30),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    height: 38,
                    child: Row(
                      children: [
                        const Icon(LucideIcons.edit,
                            color: Colors.green, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Chỉnh sửa',
                          style: GoogleFonts.beVietnamPro(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    PopupMenuItem<String>(
                      value: 'delete',
                      height: 38,
                      child: Row(
                        children: [
                          const Icon(LucideIcons.trash2,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Xóa',
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    LucideIcons.moreVertical,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
