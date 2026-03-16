import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/di/injection_container.dart' as di;
import 'package:app_family_tree/resource/app_theme.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/bloc/tree_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/bloc/member_form_bloc.dart';
import 'package:app_family_tree/features/family_tree/presentation/member/widgets/add_member_dialog.dart';
import 'package:app_family_tree/features/family_tree/presentation/dashboard/pages/family_dashboard_page.dart';
import 'package:app_family_tree/features/family_tree/presentation/tree/pages/tree_view_page.dart';

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
      body: ShellIndexProvider(
        currentIndex: _currentIndex,
        child: IndexedStack(
          index: _currentIndex,
          children: const [FamilyDashboardPage(), TreeViewPage()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'main_fab',
        onPressed: () {
          final treeBloc = context.read<TreeBloc>();
          showDialog(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.6),
            builder: (ctx) => MultiBlocProvider(
              providers: [
                BlocProvider<MemberFormBloc>(
                  create: (_) => di.sl<MemberFormBloc>(),
                ),
                BlocProvider.value(value: treeBloc),
              ],
              child: const AddMemberDialog(),
            ),
          );
        },
        backgroundColor: AppColors.crimson,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.gold, width: 1.5),
        ),
        child: const Icon(Icons.person_add_rounded, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 70 + MediaQuery.of(context).padding.bottom,
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
              offset: const Offset(0, -5),
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
                child: Image.asset(
                  'assets/images/wood_dragon.png',
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.4),
                  colorBlendMode: BlendMode.darken,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              ),
            ),
            // Navigation Items
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  children: [
                    _buildNavItem(context, 0, Icons.home_rounded, 'Trang chủ'),
                    const SizedBox(width: 56),
                    _buildNavItem(
                      context,
                      1,
                      Icons.account_tree_rounded,
                      'Sơ đồ',
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
