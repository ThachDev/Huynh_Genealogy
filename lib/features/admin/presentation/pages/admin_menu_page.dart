import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../admin.dart';

class AdminMenuPage extends StatelessWidget {
  const AdminMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: AppBar(
        backgroundColor: AppColors.wood,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'DANH MỤC QUẢN TRỊ',
          style: GoogleFonts.beVietnamPro(
            color: AppColors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 17,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
        children: [
          _AdminMenuCard(
            icon: LucideIcons.users,
            label: 'Quản lý\nThành viên',
            color: AppColors.crimson,
            onTap: () {
              Navigator.push(
                context,
                FadeScalePageRoute(page: const AdminMemberFormPage()),
              );
            },
          ),
          _AdminMenuCard(
            icon: LucideIcons.clipboardList,
            label: 'Duyệt Yêu\nCầu Tham Gia',
            color: Colors.orange.shade800,
            badge: '?',
            onTap: () {
              Navigator.push(
                context,
                FadeScalePageRoute(page: const AdminPendingRequestsPage()),
              );
            },
          ),
          _AdminMenuCard(
            icon: LucideIcons.shieldAlert,
            label: 'Phân quyền\nThành viên',
            color: Colors.teal.shade700,
            onTap: () {
              Navigator.push(
                context,
                FadeScalePageRoute(page: const AdminMemberRolesPage()),
              );
            },
          ),
          _AdminMenuCard(
            icon: LucideIcons.qrCode,
            label: 'Mã Mời\nGia Tộc',
            color: Colors.indigo.shade700,
            onTap: () {
              Navigator.push(
                context,
                FadeScalePageRoute(page: const AdminInviteCodePage()),
              );
            },
          ),
          _AdminMenuCard(
            icon: LucideIcons.gitBranch,
            label: 'Quản lý\nChi Tộc',
            color: Colors.brown.shade700,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trang quản lý chi tộc – sắp ra mắt')),
              );
            },
          ),
          _AdminMenuCard(
            icon: LucideIcons.settings,
            label: 'Cài đặt\nGia Tộc',
            color: Colors.blueGrey.shade700,
            onTap: () {
              Navigator.push(
                context,
                FadeScalePageRoute(page: const AdminSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Menu Card Widget ──────────────────────────────────────────────────────────
class _AdminMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  const _AdminMenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.12)),
          ),
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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
