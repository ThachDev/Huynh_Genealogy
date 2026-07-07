import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'package:giatocviet/core/domain/entity/branch_entity.dart';

class UserBranchCard extends StatelessWidget {
  final BranchEntity branch;
  final bool isSelected;
  final VoidCallback? onTap;

  const UserBranchCard({
    super.key,
    required this.branch,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? context.primary : context.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? context.accent
                : context.accent.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: context.resolve(Colors.black.withValues(alpha: 0.05), Colors.transparent),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : context.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                LucideIcons.gitBranch,
                color: isSelected ? Colors.white : context.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    branch.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : context.textPrimary,
                    ),
                  ),
                  if (branch.founderName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      l10n.founderFormat(branch.founderName!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: isSelected
                            ? Colors.white70
                            : context.textSecondary,
                      ),
                    ),
                  ],
                  if (branch.region != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 14,
                          color: isSelected
                              ? Colors.white60
                              : context.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            branch.region!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white60
                                  : context.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (branch.foundingYear != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white24 : context.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${branch.foundingYear}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : context.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
