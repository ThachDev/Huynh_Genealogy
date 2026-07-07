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
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: context.accent,
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
                    color: context.accent.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: context.textPrimary.withValues(alpha: 0.08),
                  child: Icon(
                    LucideIcons.gitBranch,
                    color: context.textPrimary,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      branch.name,
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
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: context.nodeMale.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: context.nodeMale,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.users,
                                size: 10,
                                color: context.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.memberCountBadge(memberCount),
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (branch.founderName != null &&
                        branch.founderName!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
    );
  }
}
