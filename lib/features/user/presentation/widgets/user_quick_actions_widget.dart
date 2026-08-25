import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Widget Lối tắt hành động nhanh (Quick Actions Hub) 3 nút trọng tâm trên User Dashboard:
/// 1. Chi tộc
/// 2. Giỗ & sinh nhật
/// 3. Mã gia tộc / giới thiệu
class UserQuickActionsWidget extends StatelessWidget {
  const UserQuickActionsWidget({
    super.key,
    required this.onOpenBranches,
    required this.onGoToAnniversaries,
    required this.onOpenInviteCode,
  });

  final VoidCallback onOpenBranches;
  final VoidCallback onGoToAnniversaries;
  final VoidCallback onOpenInviteCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.resolve(
            Colors.black.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Chi tộc
          _buildActionButton(
            context: context,
            icon: LucideIcons.gitBranch,
            label: l10n.branchTabLabel,
            onTap: onOpenBranches,
          ),

          // 2. Giỗ & Sinh nhật
          _buildActionButton(
            context: context,
            icon: LucideIcons.calendarDays,
            label: l10n.anniversariesTitle,
            onTap: onGoToAnniversaries,
          ),

          // 3. Mã gia tộc
          _buildActionButton(
            context: context,
            icon: LucideIcons.qrCode,
            label: l10n.clanCodeLabel.replaceAll(':', '').trim(),
            onTap: onOpenInviteCode,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final iconColor = context.textPrimary;
    final boxBgColor = context.resolve(
      Colors.black.withValues(alpha: 0.04),
      Colors.white.withValues(alpha: 0.08),
    );
    final boxBorderColor = context.resolve(
      Colors.black.withValues(alpha: 0.08),
      Colors.white.withValues(alpha: 0.12),
    );

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: boxBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: boxBorderColor,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                  height: 1.15,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
