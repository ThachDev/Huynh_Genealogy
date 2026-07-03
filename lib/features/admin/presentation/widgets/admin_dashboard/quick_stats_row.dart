import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../pages/admin_dashboard/admin_dashboard_page.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: StatItem(
              icon: LucideIcons.users,
              label: 'THÀNH VIÊN',
              value: memberCount,
              isSelected: selectedTab == AdminDashboardTab.members,
              onTap: () => onTabChanged(AdminDashboardTab.members),
            ),
          ),
          Container(width: 1, height: 32, color: Colors.grey.shade100),
          Expanded(
            child: StatItem(
              icon: LucideIcons.menu,
              label: 'CHI TỘC',
              value: branchCount,
              isSelected: selectedTab == AdminDashboardTab.branches,
              onTap: () => onTabChanged(AdminDashboardTab.branches),
            ),
          ),
          if (showPending) ...[
            Container(width: 1, height: 32, color: Colors.grey.shade100),
            Expanded(
              child: StatItem(
                icon: LucideIcons.clock,
                label: 'CHỜ DUYỆT',
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

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const StatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.gold.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.gold.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: GoogleFonts.beVietnamPro(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
