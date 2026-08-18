import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Các phím tắt nhanh (Quick Shortcuts) cho Dashboard Người Dùng:
/// - Phả Đồ
/// - Sự Kiện
/// - Ngày Lễ / Giỗ
/// - Tra Cứu
class UserQuickActionsWidget extends StatelessWidget {
  final VoidCallback onTreeTap;
  final VoidCallback onEventsTap;
  final VoidCallback onAnniversariesTap;
  final VoidCallback onSearchTap;

  const UserQuickActionsWidget({
    super.key,
    required this.onTreeTap,
    required this.onEventsTap,
    required this.onAnniversariesTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            context: context,
            icon: LucideIcons.gitFork,
            label: 'Phả đồ',
            tintColor: const Color(0xFF8B1E1E), // Truyền thống đỏ trầm
            onTap: onTreeTap,
          ),
          _buildActionButton(
            context: context,
            icon: LucideIcons.calendarDays,
            label: 'Sự kiện',
            tintColor: const Color(0xFFC28135), // Vàng đồng
            onTap: onEventsTap,
          ),
          _buildActionButton(
            context: context,
            icon: LucideIcons.flame,
            label: 'Lễ giỗ',
            tintColor: const Color(0xFFD97706), // Cam hương hoả
            onTap: onAnniversariesTap,
          ),
          _buildActionButton(
            context: context,
            icon: LucideIcons.search,
            label: 'Tra cứu',
            tintColor: const Color(0xFF2563EB), // Xanh dương tra cứu
            onTap: onSearchTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color tintColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: tintColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: tintColor.withValues(alpha: 0.18),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 22,
                  color: tintColor,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
