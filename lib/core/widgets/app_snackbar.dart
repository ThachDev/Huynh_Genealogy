import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

enum SnackBarType { success, error, info, warning }

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colors = _colorsFor(type);
    final icon = _iconFor(type);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: colors.background,
          duration: duration,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: colors.border, width: 1),
          ),
          content: Row(
            children: [
              Icon(icon, color: colors.icon, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.inter(
                    color: colors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: colors.icon,
                  onPressed: onAction ?? () {},
                )
              : null,
        ),
      );
  }

  static void success(BuildContext context, String message,
          {String? actionLabel, VoidCallback? onAction}) =>
      show(context,
          message: message,
          type: SnackBarType.success,
          actionLabel: actionLabel,
          onAction: onAction);

  static void error(BuildContext context, String message,
          {String? actionLabel, VoidCallback? onAction}) =>
      show(context,
          message: message,
          type: SnackBarType.error,
          duration: const Duration(seconds: 4),
          actionLabel: actionLabel,
          onAction: onAction);

  static void info(BuildContext context, String message,
          {String? actionLabel, VoidCallback? onAction}) =>
      show(context,
          message: message,
          type: SnackBarType.info,
          actionLabel: actionLabel,
          onAction: onAction);

  static void warning(BuildContext context, String message,
          {String? actionLabel, VoidCallback? onAction}) =>
      show(context,
          message: message,
          type: SnackBarType.warning,
          actionLabel: actionLabel,
          onAction: onAction);

  static _SnackBarColors _colorsFor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const _SnackBarColors(
          background: Color(0xFF1B2E1B),
          border: AppColors.success,
          icon: AppColors.success,
          text: Colors.white,
        );
      case SnackBarType.error:
        return const _SnackBarColors(
          background: Color(0xFF2E1B1B),
          border: AppColors.error,
          icon: AppColors.error,
          text: Colors.white,
        );
      case SnackBarType.warning:
        return const _SnackBarColors(
          background: Color(0xFF2E251B),
          border: AppColors.gold,
          icon: AppColors.gold,
          text: Colors.white,
        );
      case SnackBarType.info:
        return _SnackBarColors(
          background: const Color(0xFF1B1F2E),
          border: AppColors.nodeMale.withOpacity(0.5),
          icon: AppColors.nodeFemale,
          text: Colors.white,
        );
    }
  }

  static IconData _iconFor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline_rounded;
      case SnackBarType.error:
        return Icons.error_outline_rounded;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.info:
        return Icons.info_outline_rounded;
    }
  }
}

class _SnackBarColors {
  final Color background;
  final Color border;
  final Color icon;
  final Color text;
  const _SnackBarColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.text,
  });
}
