import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/theme_extensions.dart';
import '../../resources/app_localizations.dart';
import '../../features/auth/auth.dart';
import '../../features/user/presentation/pages/user_family_dashboard_page.dart';
import '../../features/user/presentation/pages/user_settings_page.dart';
import '../../features/family_tree/presentation/pages/family_tree_view_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/setting_dashboard/admin_settings_page.dart';

class UserMainNavigationPage extends StatefulWidget {
  const UserMainNavigationPage({super.key});

  static final ValueNotifier<bool> adminModeNotifier =
      ValueNotifier<bool>(true);

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
        final List<_TabConfig> tabs = [];

        if (showAdminInterface) {
          // Admin: Tổng quan, Cây gia phả, Quỹ gia tộc, Cài đặt
          tabs.add(_TabConfig(
            icon: LucideIcons.layoutDashboard,
            label: l10n.navOverview,
            page: const AdminDashboardPage(),
          ));

          tabs.add(_TabConfig(
            icon: LucideIcons.network,
            label: l10n.navFamilyTree,
            page: const FamilyTreeViewPage(),
          ));

          tabs.add(_TabConfig(
            icon: LucideIcons.settings,
            label: l10n.navSettings,
            page: const AdminSettingsPage(),
          ));
        } else {
          // User thường: Tổng quan, Cây gia phả, Quỹ gia tộc, Cài đặt
          tabs.add(_TabConfig(
            icon: LucideIcons.home,
            label: l10n.navOverview,
            page: const UserFamilyDashboardPage(),
          ));

          tabs.add(_TabConfig(
            icon: LucideIcons.network,
            label: l10n.navFamilyTree,
            page: const FamilyTreeViewPage(),
          ));

          tabs.add(_TabConfig(
            icon: LucideIcons.settings,
            label: l10n.navSettings,
            page: const UserSettingsPage(),
          ));
        }

        // Đảm bảo currentIndex không vượt quá phạm vi nếu chế độ thay đổi
        final safeIndex = _currentIndex >= tabs.length ? 0 : _currentIndex;

        return Scaffold(
          key: ValueKey<bool>(showAdminInterface),
          body: IndexedStack(
            index: safeIndex,
            children: tabs.map((t) => t.page).toList(),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: context.surface,
              boxShadow: [
                BoxShadow(
                  color: context.resolve(Colors.black.withValues(alpha: 0.08),
                      Colors.white.withValues(alpha: 0.08)),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final tab = tabs[index];
                    return _BottomTabItem(
                      icon: tab.icon,
                      label: tab.label,
                      isSelected: safeIndex == index,
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      selectedColor: context.primary,
                      unselectedColor: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabConfig {
  final IconData icon;
  final String label;
  final Widget page;

  _TabConfig({
    required this.icon,
    required this.label,
    required this.page,
  });
}

class _BottomTabItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const _BottomTabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  State<_BottomTabItem> createState() => _BottomTabItemState();
}

class _BottomTabItemState extends State<_BottomTabItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.82)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.82, end: 1.15)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _BottomTabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.isSelected ? widget.selectedColor : widget.unselectedColor;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _controller.forward(from: 0.0);
          widget.onTap();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                widget.icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}
