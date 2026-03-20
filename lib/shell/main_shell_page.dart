import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/features/dashboard/presentation/pages/family_dashboard_page.dart';
import 'package:app_family_tree/features/tree/presentation/pages/tree_view_page.dart';
import 'package:app_family_tree/features/events/presentation/pages/events_page.dart';
import 'package:app_family_tree/features/settings/presentation/settings_page.dart';
import 'package:resources/resources.dart';

class ShellIndexProvider extends InheritedWidget {
  final int currentIndex;

  const ShellIndexProvider({
    super.key,
    required this.currentIndex,
    required super.child,
  });

  static int of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<ShellIndexProvider>()
            ?.currentIndex ??
        0;
  }

  @override
  bool updateShouldNotify(ShellIndexProvider oldWidget) {
    return currentIndex != oldWidget.currentIndex;
  }
}

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  void _onTap(BuildContext context, int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ShellIndexProvider(
        currentIndex: _currentIndex,
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            FamilyDashboardPage(),
            TreeViewPage(),
            EventsPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: AppColors.wood,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Stack(
          children: [
            // Wood Dragon Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/wood_dragon.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.3)),
                  ],
                ),
              ),
            ),
            // Navigation Items
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: (MediaQuery.of(context).padding.bottom - 15).clamp(
                    0,
                    double.infinity,
                  ),
                ),
                child: Row(
                  children: [
                    _buildNavItem(
                      context,
                      0,
                      Icons.home_rounded,
                      S.of(context).home,
                    ),
                    _buildNavItem(
                      context,
                      1,
                      Icons.account_tree_rounded,
                      S.of(context).diagram,
                    ),
                    _buildNavItem(
                      context,
                      2,
                      Icons.event_note_rounded,
                      S.of(context).event,
                    ),
                    _buildNavItem(
                      context,
                      3,
                      Icons.menu_rounded,
                      S.of(context).settings,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTap(context, index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected ? AppColors.gold : Colors.white54,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? AppColors.gold : Colors.white54,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
