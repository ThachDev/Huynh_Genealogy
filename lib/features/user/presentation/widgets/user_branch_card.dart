import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../resources/app_localizations.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_common_widgets.dart';
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

    final borderColor =
        isSelected ? context.accent : context.accent.withValues(alpha: 0.45);
    final fillColor =
        isSelected ? context.primary : context.surface.withValues(alpha: 0.90);
    final textPrimary = isSelected ? Colors.white : context.textPrimary;
    final textSecondary = isSelected ? Colors.white70 : context.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: CustomPaint(
          painter: TraditionalOrnamentalBorderPainter(
            borderColor: borderColor,
            fillColor: fillColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon trơn
                Icon(
                  LucideIcons.gitBranch,
                  color: isSelected ? Colors.white : context.primary,
                  size: 26,
                ),
                const SizedBox(width: 12),
                // Nội dung
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hàng 1: Tên chi tộc + Năm (top-right)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              branch.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          if (branch.foundingYear != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.18)
                                    : context.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${branch.foundingYear}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : context.accent,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Hàng 2: Chi trưởng
                      if (branch.founderName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.founderFormat(branch.founderName!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                      // Hàng 3: Khu vực
                      if (branch.region != null) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 12,
                              color: textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                branch.region!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
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
