import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          background: Color(0xFFE6F4E6),
          icon: Color(0xFF2E7D32),
          text: Color(0xFF1B5E20),
        );
      case SnackBarType.error:
        return const _SnackBarColors(
          background: Color(0xFFFDEAEA),
          icon: Color(0xFFC62828),
          text: Color(0xFF8E1C1C),
        );
      case SnackBarType.warning:
        return const _SnackBarColors(
          background: Color(0xFFFFF4DF),
          icon: Color(0xFFB8860B),
          text: Color(0xFF7A5C00),
        );
      case SnackBarType.info:
        return const _SnackBarColors(
          background: Color(0xFFE8EDF8),
          icon: Color(0xFF3F51B5),
          text: Color(0xFF283593),
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
  final Color icon;
  final Color text;
  const _SnackBarColors({
    required this.background,
    required this.icon,
    required this.text,
  });
}
