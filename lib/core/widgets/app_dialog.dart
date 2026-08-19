import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../resources/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
import 'app_button.dart';
import 'app_common_widgets.dart';
import 'app_text_field.dart';

enum AppDialogType { info, warning, danger, success }

class AppDialog {
  AppDialog._();

  /// Dialog xác nhận có 2 nút: Huỷ + Xác nhận
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    required String message,
    InlineSpan? messageSpan,
    String? confirmLabel,
    String? cancelLabel,
    AppDialogType type = AppDialogType.warning,
    bool showIcon = true,
    Color? confirmColor,
  }) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        messageSpan: messageSpan,
        confirmLabel: confirmLabel ?? l10n.confirmLabel,
        cancelLabel: cancelLabel ?? l10n.cancelLabel,
        type: type,
        showCancel: true,
        showIcon: showIcon,
        confirmColor: confirmColor,
      ),
    );
  }

  /// Dialog xác nhận 2 bước yêu cầu nhập đúng từ khoá (ví dụ: "XÁC NHẬN" hoặc "GIẢI TÁN")
  static Future<bool?> confirmWithInput(
    BuildContext context, {
    required String title,
    required String message,
    required String requiredWord,
    required String inputInstruction,
    String? confirmLabel,
    String? cancelLabel,
    AppDialogType type = AppDialogType.danger,
  }) {
    final l10n = AppLocalizations.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppInputDialogWidget(
        title: title,
        message: message,
        requiredWord: requiredWord,
        inputInstruction: inputInstruction,
        confirmLabel: confirmLabel ?? l10n.confirmLabel,
        cancelLabel: cancelLabel ?? l10n.cancelLabel,
        type: type,
      ),
    );
  }

  /// Dialog thông báo chỉ có 1 nút OK
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    String? okLabel,
    AppDialogType type = AppDialogType.info,
  }) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        confirmLabel: okLabel ?? l10n.okLabel,
        type: type,
        showCancel: false,
      ),
    );
  }

  /// Dialog loading – không thể đóng bằng back/tap ngoài
  static Future<void> showLoading(
    BuildContext context, {
    String? message,
  }) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: AppColors.wood,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoading(size: 60),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    message ?? l10n.loadingMessage,
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

  const _AppDialogWidget({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.type,
    required this.showCancel,
    this.messageSpan,
    this.showIcon = true,
    this.cancelLabel,
    this.confirmColor,
  });
  final String title;
  final String message;
  final InlineSpan? messageSpan;
  final String confirmLabel;
  final String? cancelLabel;
  final AppDialogType type;
  final bool showCancel;
  final bool showIcon;
  final Color? confirmColor;

  @override
  Widget build(BuildContext context) {
    final accentColor = confirmColor ?? _accentColor(context);
    final icon = _icon();

    return Dialog(
      backgroundColor: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (showIcon) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 28),
              ),
              const SizedBox(height: 16),
            ],

            // Title
            Align(
              alignment: showIcon ? Alignment.center : Alignment.centerLeft,
              child: Text(
                title,
                textAlign: showIcon ? TextAlign.center : TextAlign.left,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: showIcon ? context.textPrimary : accentColor,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Message
            Align(
              alignment: showIcon ? Alignment.center : Alignment.centerLeft,
              child: messageSpan != null
                  ? Text.rich(
                      messageSpan!,
                      textAlign:
                          showIcon ? TextAlign.center : TextAlign.justify,
                    )
                  : Text(
                      message,
                      textAlign:
                          showIcon ? TextAlign.center : TextAlign.justify,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.5,
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Buttons
            if (showCancel)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      cancelLabel ?? AppLocalizations.of(context).cancelLabel,
                      style: GoogleFonts.inter(
                        color: context.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    label: confirmLabel,
                    onPressed: () => Navigator.of(context).pop(true),
                    color: accentColor,
                    size: AppButtonSize.small,
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
                    foregroundColor: type == AppDialogType.warning ||
                            (type == AppDialogType.info && !context.isDarkMode)
                        ? Colors.black87
                        : context.textOnPrimary,
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

  Color _accentColor(BuildContext context) {
    switch (type) {
      case AppDialogType.danger:
        return context.error;
      case AppDialogType.warning:
        return context.accent;
      case AppDialogType.success:
        return AppColors.success;
      case AppDialogType.info:
        return context.nodeFemale;
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

class _AppInputDialogWidget extends StatefulWidget {

  const _AppInputDialogWidget({
    required this.title,
    required this.message,
    required this.requiredWord,
    required this.inputInstruction,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.type,
  });
  final String title;
  final String message;
  final String requiredWord;
  final String inputInstruction;
  final String confirmLabel;
  final String cancelLabel;
  final AppDialogType type;

  @override
  State<_AppInputDialogWidget> createState() => _AppInputDialogWidgetState();
}

class _AppInputDialogWidgetState extends State<_AppInputDialogWidget> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final valid = _controller.text.trim().toUpperCase() ==
        widget.requiredWord.trim().toUpperCase();
    if (valid != _isValid) {
      setState(() => _isValid = valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = widget.type == AppDialogType.danger
        ? context.primary
        : (widget.type == AppDialogType.warning
            ? context.accent
            : context.textPrimary);

    // Tách chuỗi instruction để in đậm từ khoá cần nhập (ví dụ "XÁC NHẬN")
    final word = widget.requiredWord;
    final instruction = widget.inputInstruction;
    final List<InlineSpan> instructionSpans = [];

    if (instruction.contains(word)) {
      final parts = instruction.split(word);
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].isNotEmpty) {
          instructionSpans.add(TextSpan(text: parts[i]));
        }
        if (i < parts.length - 1) {
          instructionSpans.add(
            TextSpan(
              text: word,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
          );
        }
      }
    } else {
      instructionSpans.add(TextSpan(text: instruction));
    }

    return Dialog(
      backgroundColor: context.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title (Căn trái, chữ đỏ sẫm truyền thống)
            Text(
              widget.title,
              textAlign: TextAlign.left,
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),

            // Message (Căn trái)
            Text(
              widget.message,
              textAlign: TextAlign.left,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: context.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Instruction Label với từ khoá "XÁC NHẬN" / "GIẢI TÁN" IN ĐẬM
            Text.rich(
              TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: context.textSecondary,
                  height: 1.4,
                ),
                children: instructionSpans,
              ),
            ),
            const SizedBox(height: 10),

            // Text Input Field chuẩn hệ thống
            AppTextFieldLight(
              label: '',
              controller: _controller,
              hintText: widget.requiredWord,
            ),
            const SizedBox(height: 24),

            // Buttons row (Huỷ + Xác nhận)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    widget.cancelLabel,
                    style: GoogleFonts.inter(
                      color: context.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: widget.confirmLabel,
                  onPressed:
                      _isValid ? () => Navigator.of(context).pop(true) : null,
                  size: AppButtonSize.small,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
