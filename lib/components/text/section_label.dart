import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry? padding;

  const SectionLabel(this.label, {super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.gold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
