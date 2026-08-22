import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../family_tree/domain/entities/member_entity.dart';
import '../../../../../resources/app_localizations.dart';
import '../../../../../core/widgets/widgets.dart';

import '../../../../family_tree/presentation/pages/family_member_detail_page.dart';

class MemberItemWidget extends StatelessWidget {

  const MemberItemWidget({
    super.key,
    required this.member,
    this.allMembers = const [],
    this.onEdit,
    this.onDelete,
    this.showMenu = true,
    this.useOrnamentalBorder = true,
  });
  final MemberEntity member;
  final List<MemberEntity> allMembers;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showMenu;
  final bool useOrnamentalBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          SereneFadeSlidePageRoute(
            page: FamilyMemberDetailPage(
              member: member,
              allMembers: allMembers,
            ),
          ),
        );
        if (result == true) {
          onEdit?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.accent.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final String aliveText =
        member.isAlive ? l10n.aliveLabel : l10n.deceasedLabel;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      child: Row(
        children: [
          // ── Avatar ──
          AppAvatar(
            avatarUrl: member.avatarUrl,
            fullName: member.fullName,
            radius: 26,
            fontSize: 18,
          ),
          const SizedBox(width: 14),

          // ── Thông tin ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row 1: Họ tên + Status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.fullName,
                        style: GoogleFonts.beVietnamPro(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: context.textPrimary,
                          letterSpacing: -0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: member.isAlive
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        aliveText,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: member.isAlive
                              ? Colors.green.shade700
                              : context.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (member.linkedUserEmail != null &&
                    member.linkedUserEmail!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mail,
                        size: 11,
                        color: context.primary.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          member.linkedUserEmail!,
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: context.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 4),

                // Row 2: Đời + Chi
                Row(
                  children: [
                    Icon(LucideIcons.users,
                        size: 12,
                        color: context.textSecondary.withValues(alpha: 0.7)),
                    const SizedBox(width: 4),
                    Text(
                      l10n.generationLabel('${member.generation ?? "?"}'),
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: context.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (member.branchName != null &&
                        member.branchName!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '|',
                        style: TextStyle(
                          color: context.resolve(
                              Colors.grey.shade400, Colors.grey.shade700),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(LucideIcons.network,
                          size: 12,
                          color: context.textSecondary.withValues(alpha: 0.7)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.branchBadge(member.branchName!),
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            color: context.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ── Menu ──
          if (showMenu) ...[
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: context.surface,
              elevation: 4,
              offset: const Offset(18, 30),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit?.call();
                } else if (value == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem<String>(
                    value: 'edit',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(LucideIcons.edit,
                            color: context.textPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(l10n.editLabel,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: context.textPrimary)),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  PopupMenuItem<String>(
                    value: 'delete',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2,
                            color: context.textPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text(l10n.deleteLabel,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: context.textPrimary)),
                      ],
                    ),
                  ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(LucideIcons.moreVertical,
                    color: context.textSecondary, size: 20),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
