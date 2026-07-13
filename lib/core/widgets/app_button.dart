import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';
import 'app_common_widgets.dart';
import '../../resources/app_localizations.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = _buttonStyle(context);
    final height = _height();
    final fontSize = _fontSize();

    final content = isLoading
        ? const AppLoading(size: 40)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                suffixIcon!,
              ],
            ],
          );

    final button = _buildButton(style, content, height);

    return fullWidth
        ? SizedBox(width: double.infinity, height: height, child: button)
        : SizedBox(height: height, child: button);
  }

  Widget _buildButton(ButtonStyle style, Widget content, double height) {
    switch (variant) {
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: content,
        );
      default:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: content,
        );
    }
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: context.primary,
          foregroundColor: context.textOnPrimary,
          disabledBackgroundColor: context.primary.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: context.accent,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: context.accent.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      case AppButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: context.accent,
          side: BorderSide(color: context.accent, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      case AppButtonVariant.ghost:
        return OutlinedButton.styleFrom(
          foregroundColor: context.textSecondary,
          side: BorderSide(color: context.textSecondary.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      case AppButtonVariant.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.error.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
    }
  }

  double _height() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _fontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 12;
      case AppButtonSize.medium:
        return 14;
      case AppButtonSize.large:
        return 16;
    }
  }
}

class AppFormActionButtons extends StatelessWidget {
  /// Nhãn nút lưu (mặc định 'LƯU LẠI')
  final String? saveLabel;

  /// Nhãn nút hủy (mặc định 'HỦY BỎ')
  final String? cancelLabel;

  /// Callback khi nhấn nút lưu
  final VoidCallback? onSave;

  /// Callback khi nhấn nút hủy — mặc định pop navigation
  final VoidCallback? onCancel;

  /// Hiển thị loading trên nút lưu
  final bool isLoading;

  const AppFormActionButtons({
    super.key,
    this.saveLabel,
    this.cancelLabel,
    this.onSave,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final save = saveLabel ?? l10n.formSave;
    final cancel = cancelLabel ?? l10n.formCancel;
    final cancelColor = context.textSecondary;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: cancelColor, width: 1.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              cancel,
              style: GoogleFonts.beVietnamPro(
                fontWeight: FontWeight.bold,
                color: cancelColor,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primary,
              foregroundColor: context.textOnPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    save,
                    style: GoogleFonts.beVietnamPro(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Icon button tròn dùng chung
class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final btn = InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ??
              (context.isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05)),
          shape: BoxShape.circle,
          border: Border.all(color: context.accent.withValues(alpha: 0.3)),
        ),
        child: Center(child: icon),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }
}
