import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme.dart';
import '../../resources/app_localizations.dart';
import '../../features/auth/auth.dart';
import '../../features/user/presentation/pages/user_family_dashboard_page.dart';
import '../../features/user/presentation/pages/user_tree_view_page.dart';
import '../../features/user/presentation/pages/user_settings_page.dart';
import '../../features/family_fund/family_fund.dart';
import '../../features/admin/presentation/pages/admin_dashboard/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/setting_dashboard/admin_settings_page.dart';

class UserMainNavigationPage extends StatefulWidget {
  const UserMainNavigationPage({super.key});

  static final ValueNotifier<bool> adminModeNotifier = ValueNotifier<bool>(true);

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
    final hasAdminPrivileges = _isAdminRole(role);

    if (!hasAdminPrivileges) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (UserMainNavigationPage.adminModeNotifier.value != false) {
          UserMainNavigationPage.adminModeNotifier.value = false;
        }
      });
    }

    return ValueListenableBuilder<bool>(
      valueListenable: UserMainNavigationPage.adminModeNotifier,
      builder: (context, isCurrentlyAdminMode, _) {
        final showAdminInterface = hasAdminPrivileges && isCurrentlyAdminMode;
        final l10n = AppLocalizations.of(context)!;

        // Xây dựng danh sách các trang dựa trên chế độ hiển thị
        final List<Widget> pages = [];
        final List<BottomNavigationBarItem> navigationItems = [];

        if (showAdminInterface) {
          // Admin: Tổng quan, Cây gia phả, Quỹ gia tộc, Cài đặt
          pages.add(const AdminDashboardPage());
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.layoutDashboard),
            label: l10n.navOverview,
          ));

          pages.add(const UserTreeViewPage());
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.gitBranch),
            label: l10n.navFamilyTree,
          ));

          final canManageFund =
              role == 'OWNER' || role == 'CREATOR' || role == 'BRANCH_ADMIN';
          pages.add(FamilyFundPage(isAdmin: canManageFund));
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.wallet),
            label: l10n.navFamilyFund,
          ));

          pages.add(const AdminSettingsPage());
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.settings),
            label: l10n.navSettings,
          ));
        } else {
          // User thường: Tổng quan, Cây gia phả, Quỹ gia tộc, Cài đặt
          pages.add(const UserFamilyDashboardPage());
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.home),
            label: l10n.navOverview,
          ));

          pages.add(const UserTreeViewPage());
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.gitBranch),
            label: l10n.navFamilyTree,
          ));

          pages.add(const FamilyFundPage(isAdmin: false));
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.wallet),
            label: l10n.navFamilyFund,
          ));

          pages.add(const UserSettingsPage());
          navigationItems.add(BottomNavigationBarItem(
            icon: const Icon(LucideIcons.settings),
            label: l10n.navSettings,
          ));
        }

        // Đảm bảo currentIndex không vượt quá phạm vi nếu chế độ thay đổi
        final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

        return Scaffold(
          key: ValueKey<bool>(showAdminInterface),
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
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: AppColors.crimson,
              unselectedItemColor: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
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
      },
    );
  }
}
