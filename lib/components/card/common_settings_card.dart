import 'package:flutter/material.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';

class CommonSettingsCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const CommonSettingsCard({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.gold.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
