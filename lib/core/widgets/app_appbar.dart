import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_extensions.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool transparent;

  const AppAppBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light, // Light icons on dark appBarBg
        statusBarBrightness: Brightness.dark, // For iOS status bar
      ),
      flexibleSpace: transparent
          ? null
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/wood_dragon_top.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: context.appBarBg),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                      color: context.resolve(
                          Colors.black.withValues(alpha: 0.45),
                          Colors.transparent)),
                ),
              ],
            ),
      shape: transparent
          ? null
          : Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1.0,
              ),
            ),
      iconTheme: const IconThemeData(color: Colors.white),
      title: titleWidget ??
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              color: context.accent,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

/// A reusable scaffold body widget that renders [child] on top of
/// the app's traditional background image (`assets/images/background.png`).
///
/// Usage:
/// ```dart
/// Scaffold(
///   appBar: AppAppBar(title: 'Page Title'),
///   body: AppBackgroundBody(
///     child: YourContent(),
///   ),
/// )
/// ```
class AppBackgroundBody extends StatelessWidget {
  const AppBackgroundBody({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
