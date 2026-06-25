import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../resources/app_localizations.dart';
import '../theme/app_theme.dart';

/// Loading indicator component using Lottie
class AppLoading extends StatelessWidget {
  final double size;

  const AppLoading({
    super.key,
    this.size = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/json/loading.json',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Loading overlay toàn màn hình
class AppLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLoading(size: 150),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Empty state widget — khi danh sách rỗng
class AppEmptyState extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.gold.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                subMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget — khi có lỗi
class AppErrorState extends StatelessWidget {
  final String message;
  final String? title;
  final String? retryLabel;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.message,
    this.title,
    this.retryLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppColors.error.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? l10n.errStateTitle,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  retryLabel ?? l10n.retryButton,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.crimson,
                  side: const BorderSide(color: AppColors.crimson),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Divider có label ở giữa
class AppLabeledDivider extends StatelessWidget {
  final String label;
  final bool? isLight;

  const AppLabeledDivider({super.key, required this.label, this.isLight});

  @override
  Widget build(BuildContext context) {
    final bool effectiveIsLight =
        isLight ?? (Theme.of(context).brightness == Brightness.light);
    final dividerColor = effectiveIsLight
        ? Colors.black.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.1);
    final textColor = effectiveIsLight
        ? AppColors.textSecondary.withValues(alpha: 0.6)
        : AppColors.nodeFemale.withValues(alpha: 0.4);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

/// Badge / chip label nhỏ
class AppBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const AppBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.crimson;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: bg.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor ?? bg,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Section Header component with red vertical indicator
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? description;
  final double titleSize;
  final double indicatorHeight;
  final double spacing;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.description,
    this.titleSize = 20.0,
    this.indicatorHeight = 20.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3.5,
              height: indicatorHeight,
              margin: EdgeInsets.only(
                  top: (titleSize - indicatorHeight) / 2 + 1, right: 12),
              decoration: BoxDecoration(
                color: AppColors.crimson,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.crimson,
                  height: 1.15,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        if (description != null) ...[
          SizedBox(height: spacing),
          Text(
            description!,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
