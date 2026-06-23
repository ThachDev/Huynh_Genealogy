import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'app_common_widgets.dart';

enum AppDialogType { info, warning, danger, success }

class AppDialog {
  AppDialog._();

  /// Dialog xác nhận có 2 nút: Huỷ + Xác nhận
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Xác nhận',
    String cancelLabel = 'Huỷ',
    AppDialogType type = AppDialogType.warning,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        type: type,
        showCancel: true,
      ),
    );
  }

  /// Dialog thông báo chỉ có 1 nút OK
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String okLabel = 'Đóng',
    AppDialogType type = AppDialogType.info,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        confirmLabel: okLabel,
        type: type,
        showCancel: false,
      ),
    );
  }

  /// Dialog loading – không thể đóng bằng back/tap ngoài
  static Future<void> showLoading(
    BuildContext context, {
    String message = 'Đang xử lý...',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppColors.wood,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoading(size: 60),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    message,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Dialog tuỳ chỉnh hoàn toàn
  static Future<T?> custom<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: child,
      ),
    );
  }
}

class _AppDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final AppDialogType type;
  final bool showCancel;

  const _AppDialogWidget({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.type,
    required this.showCancel,
    this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor();
    final icon = _icon();

    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: accentColor.withOpacity(0.3), width: 1),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 28),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white60,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            if (showCancel)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        cancelLabel ?? 'Huỷ',
                        style: GoogleFonts.inter(
                          color: Colors.white60,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: type == AppDialogType.warning ? Colors.black87 : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        confirmLabel,
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: type == AppDialogType.warning ? Colors.black87 : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    confirmLabel,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _accentColor() {
    switch (type) {
      case AppDialogType.danger:
        return AppColors.error;
      case AppDialogType.warning:
        return AppColors.gold;
      case AppDialogType.success:
        return AppColors.success;
      case AppDialogType.info:
        return AppColors.nodeFemale;
    }
  }

  IconData _icon() {
    switch (type) {
      case AppDialogType.danger:
        return Icons.delete_outline_rounded;
      case AppDialogType.warning:
        return Icons.warning_amber_rounded;
      case AppDialogType.success:
        return Icons.check_circle_outline_rounded;
      case AppDialogType.info:
        return Icons.info_outline_rounded;
    }
  }
}
