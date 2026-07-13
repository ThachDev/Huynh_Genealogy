import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/domain/entity/member_entity.dart';
import '../../../../../resources/app_localizations.dart';

import '../../../../family_tree/presentation/pages/family_member_detail_page.dart';

class MemberItemWidget extends StatelessWidget {
  final MemberEntity member;
  final List<MemberEntity> allMembers;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const MemberItemWidget({
    super.key,
    required this.member,
    this.allMembers = const [],
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String aliveText =
        member.isAlive ? l10n.aliveLabel : l10n.deceasedLabel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.textSecondary.withValues(alpha: 0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FamilyMemberDetailPage(
                  member: member,
                  allMembers: allMembers,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: member.gender == Gender.male
                      ? context.genderMale
                      : member.gender == Gender.female
                          ? context.genderFemale
                          : Colors.grey,
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.resolve(
                          Colors.grey.shade300, Colors.grey.shade700),
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: context.resolve(
                        Colors.grey.shade100, const Color(0xFF2C2C2C)),
                    backgroundImage: member.avatarUrl != null
                        ? NetworkImage(member.avatarUrl!)
                        : null,
                    child: member.avatarUrl == null
                        ? Icon(
                            member.gender == Gender.male
                                ? LucideIcons.user
                                : LucideIcons.user2,
                            color: member.gender == Gender.male
                                ? context.genderMale
                                : member.gender == Gender.female
                                    ? context.genderFemale
                                    : context.textSecondary,
                            size: 24,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
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
                          color: context.textPrimary,
                          letterSpacing: -0.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.gitCommit,
                                  size: 10,
                                  color: context.accent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.generationBadge(
                                      '${member.generation ?? "?"}'),
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: context.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '|',
                                  style: TextStyle(
                                    color: context.resolve(Colors.grey.shade400,
                                        Colors.grey.shade700),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  member.isAlive
                                      ? LucideIcons.heart
                                      : LucideIcons.heartCrack,
                                  size: 10,
                                  color: member.isAlive
                                      ? context.primary
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  aliveText,
                                  style: GoogleFonts.beVietnamPro(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: member.isAlive
                                        ? context.primary
                                        : context.textSecondary,
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.gitBranch,
                              size: 12,
                              color:
                                  context.textSecondary.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l10n.branchBadge(member.branchName!),
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 11,
                                  color: context.textSecondary,
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
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: context.surface,
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
                            l10n.editLabel,
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
                              l10n.deleteLabel,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      LucideIcons.moreVertical,
                      color: context.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
