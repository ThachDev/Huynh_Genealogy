import 'package:flutter/material.dart' as material;
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';

/// A reusable AppBar component that provides consistent branding across the app.
/// It features a wood dragon background by default.
class CommonAppBar extends material.StatelessWidget
    implements material.PreferredSizeWidget {
  final material.Widget? title;
  final String? titleText;
  final List<material.Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final material.Widget? flexibleSpace;
  final material.Color? backgroundColor;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.flexibleSpace,
    this.backgroundColor,
  });

  @override
  material.Widget build(material.BuildContext context) {
    return material.AppBar(
      backgroundColor: backgroundColor ?? AppColors.wood,
      elevation: elevation,
      centerTitle: centerTitle,
      title:
          title ??
          (titleText != null
              ? material.Text(
                  titleText!.toUpperCase(),
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: material.FontWeight.bold,
                    color: AppColors.gold,
                    fontSize: 18,
                    letterSpacing: 1.2,
                  ),
                )
              : null),
      actions: actions,
      flexibleSpace: flexibleSpace ?? _buildDefaultFlexibleSpace(),
    );
  }

  material.Widget _buildDefaultFlexibleSpace() {
    return material.Stack(
      fit: material.StackFit.expand,
      children: [
        material.Image.asset(
          'assets/images/wood_dragon.png',
          fit: material.BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              material.Container(color: AppColors.wood),
        ),
        material.Container(color: material.Colors.black.withValues(alpha: 0.3)),
      ],
    );
  }

  @override
  material.Size get preferredSize =>
      const material.Size.fromHeight(material.kToolbarHeight);
}
