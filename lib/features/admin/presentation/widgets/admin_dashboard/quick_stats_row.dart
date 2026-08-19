import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../pages/admin_dashboard/admin_dashboard_page.dart';
import '../../../../../resources/app_localizations.dart';

class QuickStatsRow extends StatelessWidget {
  final String memberCount;
  final String branchCount;
  final String pendingCount;
  final AdminDashboardTab selectedTab;
  final ValueChanged<AdminDashboardTab> onTabChanged;
  final bool showPending;

  const QuickStatsRow({
    super.key,
    required this.memberCount,
    required this.branchCount,
    required this.pendingCount,
    required this.selectedTab,
    required this.onTabChanged,
    this.showPending = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: StatCardItem(
              icon: LucideIcons.users,
              label: l10n.statMembers,
              value: memberCount,
              isSelected: selectedTab == AdminDashboardTab.members,
              onTap: () => onTabChanged(AdminDashboardTab.members),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatCardItem(
              icon: LucideIcons.gitFork,
              label: l10n.statBranches,
              value: branchCount,
              isSelected: selectedTab == AdminDashboardTab.branches,
              onTap: () => onTabChanged(AdminDashboardTab.branches),
            ),
          ),
          if (showPending) ...[
            const SizedBox(width: 8),
            Expanded(
              child: StatCardItem(
                icon: LucideIcons.clock,
                label: l10n.statusPending,
                value: pendingCount,
                isSelected: selectedTab == AdminDashboardTab.pending,
                onTap: () => onTabChanged(AdminDashboardTab.pending),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class StatCardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const StatCardItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBg = isSelected ? context.primary : context.surface;

    final Color borderColor = isSelected
        ? context.primary
        : context.textSecondary.withValues(alpha: 0.15);

    final Color numberColor = isSelected ? Colors.white : context.textPrimary;

    final Color labelColor = isSelected ? Colors.white : context.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? null
                : Border.all(
                    color: borderColor,
                    width: 1.0,
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: numberColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: labelColor,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: labelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
