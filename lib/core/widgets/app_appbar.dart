import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_extensions.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {

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
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final bool transparent;

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
                    context.isDarkMode
                        ? 'assets/images/background_appbar_dark.png'
                        : 'assets/images/background_appbar_light.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: context.appBarBg),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: context.appBarOverlay),
                ),
              ],
            ),
      shape: transparent
          ? null
          : Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
      iconTheme: IconThemeData(color: context.textPrimary),
      title: titleWidget ??
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              color: context.textPrimary,
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
    this.enableMaxWidth = true,
    this.maxWidth = 600,
  });

  final Widget child;
  final bool enableMaxWidth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgImage = isDark
        ? 'assets/images/background_dark.png'
        : 'assets/images/background.png';

    Widget content = child;
    if (enableMaxWidth) {
      content = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: content,
    );
  }
}
