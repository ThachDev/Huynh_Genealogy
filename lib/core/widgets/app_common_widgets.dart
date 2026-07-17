import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../resources/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';

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
  final double iconSize;
  final bool useCardStyle;
  final EdgeInsets? padding;

  const AppEmptyState({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.iconSize = 64,
    this.useCardStyle = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: context.accent.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
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
    );

    if (useCardStyle) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        padding: padding ?? const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: content,
      );
    }

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(32),
        child: content,
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
                  foregroundColor: context.primary,
                  side: BorderSide(color: context.primary),
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
    final useLight = isLight ?? !context.isDarkMode;
    final dividerColor = useLight
        ? Colors.black.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.1);
    final textColor = context.textSecondary.withValues(alpha: 0.6);

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
    final bg = color ?? context.primary;
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
                color: context.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.beVietnamPro(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: context.primary,
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
              color: context.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}

/// Section title with side colored line and optional trailing widget
class AppSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            color: context.primary,
          ),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
              letterSpacing: 1,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// A card with traditional Vietnamese geometric ornamental corner patterns
class TraditionalOrnamentalCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final Color? fillColor;

  const TraditionalOrnamentalCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: TraditionalOrnamentalBorderPainter(
          borderColor: context.accent.withValues(alpha: 0.5),
          fillColor: fillColor ?? context.surface,
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class TraditionalOrnamentalBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;
  final double borderRadius;
  final Color? leftAccentColor;
  final Color? bottomAccentColor;

  TraditionalOrnamentalBorderPainter({
    required this.borderColor,
    required this.fillColor,
    this.borderRadius = 18.0,
    this.leftAccentColor,
    this.bottomAccentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // Start at top edge after top-left corner
    path.moveTo(18, 0);

    // Top edge
    path.lineTo(w - 18, 0);

    // Top-Right corner curve (Curved traditional pattern)
    path.quadraticBezierTo(w - 8, 0, w - 8, 8);
    path.quadraticBezierTo(w, 8, w, 18);

    // Right edge
    path.lineTo(w, h - 18);

    // Bottom-Right corner curve (Curved traditional pattern)
    path.quadraticBezierTo(w, h - 8, w - 8, h - 8);
    path.quadraticBezierTo(w - 8, h, w - 18, h);

    // Bottom edge
    path.lineTo(18, h);

    // Bottom-Left corner curve (Curved traditional pattern)
    path.quadraticBezierTo(8, h, 8, h - 8);
    path.quadraticBezierTo(0, h - 8, 0, h - 18);

    // Left edge
    path.lineTo(0, 18);

    // Top-Left corner curve to close (Curved traditional pattern)
    path.quadraticBezierTo(0, 8, 8, 8);
    path.quadraticBezierTo(8, 0, 18, 0);

    path.close();

    // 1. Draw shadow matching the custom path shape
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.1), 4.0, true);

    // 2. Draw fill color matching the custom path shape
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Draw left accent bar (clipped to the custom path)
    if (leftAccentColor != null) {
      canvas.save();
      canvas.clipPath(path);
      final accentPaint = Paint()
        ..color = leftAccentColor!
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, 4, h), accentPaint);
      canvas.restore();
    }

    // 3b. Draw bottom accent bar (clipped to the custom path)
    if (bottomAccentColor != null) {
      canvas.save();
      canvas.clipPath(path);
      final accentPaint = Paint()
        ..color = bottomAccentColor!
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, h - 4, w, 4), accentPaint);
      canvas.restore();
    }

    // 4. Draw stroke border
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TraditionalOrnamentalBorderPainter old) =>
      old.borderColor != borderColor ||
      old.fillColor != fillColor ||
      old.leftAccentColor != leftAccentColor;
}
