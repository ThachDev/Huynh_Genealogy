import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/theme_extensions.dart';
import '../../resources/app_localizations.dart';
import '../../features/auth/auth.dart';
import '../../features/family_tree/family_tree.dart';
import '../../features/user/presentation/pages/user_family_dashboard_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/setting_dashboard/admin_settings_page.dart';
import '../../features/events/events.dart';

class FABConfig {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool show;

  const FABConfig({
    required this.icon,
    required this.label,
    this.onTap,
    this.show = true,
  });
}

class UserMainNavigationPage extends StatefulWidget {
  const UserMainNavigationPage({super.key});

  static final ValueNotifier<bool> adminModeNotifier =
      ValueNotifier<bool>(true);

  static final ValueNotifier<FABConfig?> fabNotifier =
      ValueNotifier<FABConfig?>(null);

  @override
  State<UserMainNavigationPage> createState() => _UserMainNavigationPageState();
}

class _UserMainNavigationPageState extends State<UserMainNavigationPage> {
  int _currentIndex = 0;

  static bool _isAdminRole(String role) {
    final r = role.toUpperCase();
    return r == 'OWNER' ||
        r == 'BRANCH_ADMIN' ||
        r == 'EDITOR' ||
        r == 'CREATOR';
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.select<AuthBloc, AuthState>((bloc) => bloc.state);
    final role = authState is Authenticated ? authState.user.role : 'VIEWER';
    final familyId =
        authState is Authenticated ? authState.user.familyId : null;
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
          // Admin: Tổng quan, Cây gia phả, Sự kiện, Cài đặt
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
            icon: LucideIcons.calendarDays,
            label: 'Sự kiện',
            page: EventsListPage(familyId: familyId ?? 0),
          ));

          tabs.add(_TabConfig(
            icon: LucideIcons.settings,
            label: l10n.navSettings,
            page: const AdminSettingsPage(),
          ));
        } else {
          // User: Tổng quan, Cây gia phả, Sự kiện, Cài đặt
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
            icon: LucideIcons.calendarDays,
            label: 'Sự kiện',
            page: EventsListPage(familyId: familyId ?? 0),
          ));

          tabs.add(_TabConfig(
            icon: LucideIcons.settings,
            label: l10n.navSettings,
            page: const AdminSettingsPage(),
          ));
        }

        final safeIndex = _currentIndex >= tabs.length ? 0 : _currentIndex;

        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: tabs.map((t) => t.page).toList(),
          ),
          bottomNavigationBar: CustomPaint(
            painter: BottomNavCurvePainter(
              color: context.surface,
              shadowColor: context.resolve(Colors.black, Colors.white),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(5, (index) {
                    if (index == 2) {
                      return ValueListenableBuilder<FABConfig?>(
                        valueListenable: UserMainNavigationPage.fabNotifier,
                        builder: (context, config, _) {
                          final showFab = config != null && config.show;
                          if (!showFab) {
                            return const Expanded(child: SizedBox.shrink());
                          }
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: config.onTap,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(0, -10),
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: context.primary.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: context.surface,
                                          width: 3.5,
                                        ),
                                      ),
                                      child: Icon(
                                        config.icon,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -6),
                                    child: Text(
                                      config.label,
                                      style: GoogleFonts.beVietnamPro(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.bold,
                                        color: context.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    final tabIndex = index < 2 ? index : index - 1;
                    final tab = tabs[tabIndex];
                    return _BottomTabItem(
                      icon: tab.icon,
                      label: tab.label,
                      isSelected: safeIndex == tabIndex,
                      onTap: () {
                        setState(() {
                          _currentIndex = tabIndex;
                          UserMainNavigationPage.fabNotifier.value = null;
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


class BottomNavCurvePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  BottomNavCurvePainter({required this.color, required this.shadowColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);

    final centerX = size.width / 2;
    // Bán kính và độ nhô lên của đường cong
    const curveWidth = 90.0;
    const curveHeight = 16.0;

    path.lineTo(centerX - curveWidth / 2, 0);

    // Vẽ đường cong lượn mượt mà đi lên và đi xuống
    path.cubicTo(
      centerX - curveWidth / 2.5, 0,
      centerX - curveWidth / 3.5, -curveHeight,
      centerX, -curveHeight,
    );
    path.cubicTo(
      centerX + curveWidth / 3.5, -curveHeight,
      centerX + curveWidth / 2.5, 0,
      centerX + curveWidth / 2, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Vẽ bóng đổ phía sau
    final shadowPaint = Paint()
      ..color = shadowColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

