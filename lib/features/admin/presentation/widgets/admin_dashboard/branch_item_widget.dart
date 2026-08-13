import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/domain/entity/branch_entity.dart';
import '../../../../../resources/app_localizations.dart';

class BranchItemWidget extends StatelessWidget {
  final BranchEntity branch;
  final int memberCount;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const BranchItemWidget({
    super.key,
    required this.branch,
    required this.memberCount,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDark = context.isDarkMode;
    final Color cardBg =
        isDark ? const Color(0xFF261F1B) : const Color(0xFFFFFDF8);
    final Color borderColor = isDark
        ? Colors.white10
        : const Color(0xFFE8D7B8).withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
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
                    child: Icon(
                      LucideIcons.gitBranch,
                      color: context.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              branch.name,
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
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.users,
                            size: 12,
                            color: context.textSecondary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.memberCountBadge(memberCount),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (branch.founderName != null &&
                              branch.founderName!.isNotEmpty) ...[
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
                            Icon(
                              LucideIcons.user,
                              size: 12,
                              color:
                                  context.textSecondary.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                l10n.founderBadge(branch.founderName!),
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
                          Icon(LucideIcons.edit,
                              color: context.textPrimary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            l10n.editLabel,
                            style: GoogleFonts.beVietnamPro(
                                fontSize: 13, color: context.textPrimary),
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
                            Icon(LucideIcons.trash2,
                                color: context.textPrimary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l10n.deleteLabel,
                              style: GoogleFonts.beVietnamPro(
                                  fontSize: 13, color: context.textPrimary),
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
