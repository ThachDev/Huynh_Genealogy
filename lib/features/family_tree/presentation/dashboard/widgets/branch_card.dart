import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/branch.dart';
import 'package:app_family_tree/components/card/common_card.dart';
import 'package:resources/resources.dart';

class BranchCard extends StatelessWidget {
  final BranchEntity branch;
  final bool isSelected;
  final VoidCallback? onTap;

  const BranchCard({
    super.key,
    required this.branch,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? Colors.white : AppColors.textPrimary;
    final secondaryTextColor = isSelected
        ? Colors.white70
        : AppColors.textSecondary;

    return CommonCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Row(
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppColors.parchment,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_tree_rounded,
              color: isSelected ? Colors.white : AppColors.crimson,
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
                    color: textColor,
                  ),
                ),
                if (branch.founderName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${S.of(context).ancestor}: ${branch.founderName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
                if (branch.region != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          branch.region!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: secondaryTextColor,
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
                color: isSelected ? Colors.white24 : AppColors.parchment,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${branch.foundingYear}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.crimson,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
