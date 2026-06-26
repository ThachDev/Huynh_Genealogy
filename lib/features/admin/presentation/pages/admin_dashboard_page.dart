import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/auth.dart';
import '../../admin.dart';
import '../../../user/presentation/bloc/user_tree_bloc.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  /// Role label & color helper
  static String roleLabel(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
        return 'TRƯỞNG TỘC';
      case 'BRANCH_ADMIN':
        return 'QUẢN TRỊ CHI';
      case 'EDITOR':
        return 'BIÊN SOẠN';
      default:
        return 'QUẢN TRỊ';
    }
  }

  static Color roleColor(String role) {
    switch (role.toUpperCase()) {
      case 'OWNER':
        return AppColors.crimson;
      case 'BRANCH_ADMIN':
        return Colors.orange.shade800;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double headerHeight = 180 + topPadding;

    // Resolve family name dynamically
    String familyName = 'Gia Tộc';
    if (user != null) {
      final userTreeState = context.watch<UserTreeBloc>().state;
      if (userTreeState is UserTreeLoaded && userTreeState.members.isNotEmpty) {
        final rootMember = userTreeState.members.firstWhere(
          (m) => m.generation == 1 || m.parentId == null,
          orElse: () => userTreeState.members.first,
        );
        final parts = rootMember.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = '${parts.first} Gia Tộc';
        }
      } else {
        final parts = user.fullName.trim().split(' ');
        if (parts.isNotEmpty) {
          familyName = '${parts.first} Gia Tộc';
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, user, headerHeight, familyName),
                const SizedBox(height: 50),
                _buildMenuGrid(context),
              ],
            ),
            Positioned(
              top: headerHeight - 35,
              left: 0,
              right: 0,
              child: _QuickStatsRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserEntity? user, double height,
      String familyName) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.wood,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wood_dragon.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.wood),
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.45)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            familyName.toUpperCase(),
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Text(
                            'BẢNG QUẢN TRỊ',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white60,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      if (user != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: roleColor(user.role),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            roleLabel(user.role),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar,
                          color: AppColors.gold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Thứ Sáu, 26/06/2026 • 12/05 Âm Lịch',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '“Cây có gốc mới nở cành xanh lá, nước có nguồn mới bể rộng sông sâu”',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
                FadeScalePageRoute(
                  page: const AdminMemberFormPage(),
                ),
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
                FadeScalePageRoute(
                  page: const AdminPendingRequestsPage(),
                ),
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
                FadeScalePageRoute(
                  page: const AdminMemberRolesPage(),
                ),
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
                FadeScalePageRoute(
                  page: const AdminInviteCodePage(),
                ),
              );
            },
          ),
          _AdminMenuCard(
            icon: LucideIcons.gitBranch,
            label: 'Quản lý\nChi Tộc',
            color: Colors.brown.shade700,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Trang quản lý chi tộc – sắp ra mắt')),
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
                FadeScalePageRoute(
                  page: const AdminSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Quick Stats Row ────────────────────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.wood,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const _StatItem(
              icon: LucideIcons.users, label: 'Thành viên', value: '--'),
          Container(width: 1, height: 32, color: Colors.white24),
          const _StatItem(
              icon: LucideIcons.gitBranch, label: 'Chi tộc', value: '--'),
          Container(width: 1, height: 32, color: Colors.white24),
          _StatItem(
              icon: LucideIcons.clock,
              label: 'Chờ duyệt',
              value: '--',
              valueColor: Colors.orange.shade300),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 14),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.inter(color: Colors.white60, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

// ── Admin Menu Card ────────────────────────────────────────────────────────────
class _AdminMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? badge;
  final VoidCallback onTap;

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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
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
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
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
              // Badge (e.g. pending count)
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
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
