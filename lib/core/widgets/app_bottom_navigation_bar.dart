import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme.dart';
import '../../features/auth/auth.dart';
import '../../features/user/presentation/pages/user_family_dashboard_page.dart';
import '../../features/user/presentation/pages/user_tree_view_page.dart';
import '../../features/user/presentation/pages/user_settings_page.dart';
import '../../features/family_fund/family_fund.dart';
import '../../features/admin/presentation/pages/admin_dashboard/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/setting_dashboard/admin_settings_page.dart';

class UserMainNavigationPage extends StatefulWidget {
  const UserMainNavigationPage({super.key});

  @override
  State<UserMainNavigationPage> createState() => _UserMainNavigationPageState();
}

class _UserMainNavigationPageState extends State<UserMainNavigationPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  static bool _isAdminRole(String role) {
    final r = role.toUpperCase();
    return r == 'OWNER' ||
        r == 'BRANCH_ADMIN' ||
        r == 'EDITOR' ||
        r == 'CREATOR';
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final role = user?.role ?? 'VIEWER';
    final isAdmin = _isAdminRole(role);

    // Xây dựng danh sách các trang dựa trên role
    final List<Widget> pages = [];
    final List<BottomNavigationBarItem> navigationItems = [];

    if (isAdmin) {
      // Admin: Tổng quan, Cây gia phả, Quỹ gia tộc, Cài đặt
      pages.add(const AdminDashboardPage());
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.layoutDashboard),
        label: 'Tổng quan',
      ));

      pages.add(const UserTreeViewPage());
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.gitBranch),
        label: 'Cây gia phả',
      ));

      pages.add(const FamilyFundPage(isAdmin: true));
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.wallet),
        label: 'Quỹ gia tộc',
      ));

      pages.add(const AdminSettingsPage());
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.settings),
        label: 'Cài đặt',
      ));
    } else {
      // User thường: Tổng quan, Cây gia phả, Quỹ gia tộc, Cài đặt
      pages.add(const UserFamilyDashboardPage());
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.home),
        label: 'Tổng quan',
      ));

      pages.add(const UserTreeViewPage());
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.gitBranch),
        label: 'Cây gia phả',
      ));

      pages.add(const FamilyFundPage(isAdmin: false));
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.wallet),
        label: 'Quỹ gia tộc',
      ));

      pages.add(const UserSettingsPage());
      navigationItems.add(const BottomNavigationBarItem(
        icon: Icon(LucideIcons.settings),
        label: 'Cài đặt',
      ));
    }

    // Đảm bảo currentIndex không vượt quá phạm vi nếu role thay đổi động
    final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: safeIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.crimson,
          unselectedItemColor: AppColors.textSecondary.withValues(alpha: 0.6),
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          items: navigationItems,
        ),
      ),
    );
  }
}
