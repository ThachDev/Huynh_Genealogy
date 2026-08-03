import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';

/// Wrapper hiệu ứng shimmer cho skeleton loading UI.
///
/// Tự thích ứng sáng/tối: dùng `context.textSecondary` làm màu nền placeholder
/// và chạy một gradient sáng quét qua toàn bộ child.
class AppShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AppShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.textSecondary.withValues(alpha: 0.12);
    final highlight = context.textSecondary.withValues(alpha: 0.20);

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, highlight, base],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(bounds.width * _controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

/// Dịch chuyển gradient để tạo hiệu ứng shimmer quét ngang.
class _SlidingGradientTransform extends GradientTransform {
  final double dx;

  const _SlidingGradientTransform(this.dx);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, 0, 0);
  }
}

/// Hình chữ nhật placeholder cho skeleton.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.textSecondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Hình tròn placeholder (avatar) cho skeleton.
class SkeletonCircle extends StatelessWidget {
  final double radius;

  const SkeletonCircle({super.key, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.textSecondary.withValues(alpha: 0.12),
      ),
    );
  }
}

/// Dòng text placeholder cho skeleton.
class SkeletonLine extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLine({
    super.key,
    this.width = double.infinity,
    this.height = 12,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: height, borderRadius: borderRadius);
  }
}

/// Row placeholder chuẩn: avatar tròn + 2 dòng text.
class SkeletonListTile extends StatelessWidget {
  final double avatarRadius;
  final double spacing;

  const SkeletonListTile({
    super.key,
    this.avatarRadius = 24,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SkeletonCircle(radius: avatarRadius),
        SizedBox(width: spacing),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: double.infinity, height: 14),
              SizedBox(height: 8),
              SkeletonLine(width: 120, height: 11),
            ],
          ),
        ),
      ],
    );
  }
}
