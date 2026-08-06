import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Hiển thị ảnh từ mạng có cache cục bộ (cached_network_image).
/// Tự fallback khi URL rỗng/lỗi tải.
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final WidgetBuilder? placeholderBuilder;
  final WidgetBuilder? errorBuilder;

  const AppNetworkImage({
    super.key,
    this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final url = this.url?.trim();
    if (url == null || url.isEmpty) {
      return _fallback(context);
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, _) => _fallback(context),
        errorWidget: (context, _, __) => _fallback(context),
      ),
    );
  }

  Widget _fallback(BuildContext context) {
    if (placeholderBuilder != null) return placeholderBuilder!(context);
    return Container(
      width: width,
      height: height,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.5),
    );
  }
}
