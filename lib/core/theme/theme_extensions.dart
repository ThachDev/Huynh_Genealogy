import 'package:flutter/material.dart';
import 'app_theme.dart';

extension AppThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color resolve(Color light, Color dark) => isDarkMode ? dark : light;

  Color get primary => resolve(AppColors.crimson, AppColors.crimsonLight);
  Color get accent => resolve(AppColors.gold, AppColors.goldLight);
  Color get background => resolve(AppColors.parchment, AppColors.parchmentDark);
  Color get surface => resolve(Colors.white, AppColors.surfaceDark);
  Color get appBarBg => resolve(AppColors.wood, AppColors.wood);

  Color get textPrimary => resolve(AppColors.textPrimary, Colors.white);
  Color get textSecondary => resolve(AppColors.textSecondary, Colors.white70);
  Color get textOnPrimary => AppColors.textOnPrimary;

  Color get nodeMale => resolve(AppColors.nodeMale, AppColors.nodeMaleDark);
  Color get nodeFemale => resolve(AppColors.nodeFemale, AppColors.nodeFemaleDark);
  Color get nodeDeceased => resolve(AppColors.nodeDeceased, AppColors.nodeDeceasedDark);
  Color get nodeBorder => AppColors.nodeBorder;
  Color get connectionLine => resolve(AppColors.wood, AppColors.gold);
}
