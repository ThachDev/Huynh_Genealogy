import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/theme_extensions.dart';

/// Reusable AppAvatar widget displaying NetworkImage or last word's initial letter.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.avatarUrl,
    this.fullName,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fallbackInitial = 'M',
  });
  final String? avatarUrl;
  final String? fullName;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final String fallbackInitial;

  /// Extraction logic: First letter of the LAST word of [fullName]
  static String getInitialLetter(String? fullName, {String fallback = 'M'}) {
    if (fullName == null || fullName.trim().isEmpty) return fallback;
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return fallback;
    final lastWord = parts.last;
    return lastWord.isNotEmpty ? lastWord[0].toUpperCase() : fallback;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ??
        context.primary.withValues(
          alpha: context.isDarkMode ? 0.18 : 0.12,
        );
    final effectiveTextColor = textColor ?? context.primary;
    final effectiveFontSize = fontSize ?? (radius * 0.8);

    final hasAvatarUrl = avatarUrl != null && avatarUrl!.trim().isNotEmpty;
    final initialLetter = getInitialLetter(fullName, fallback: fallbackInitial);

    if (!hasAvatarUrl) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: effectiveBgColor,
        child: Text(
          initialLetter,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.bold,
            fontSize: effectiveFontSize,
            color: effectiveTextColor,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: effectiveBgColor,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: avatarUrl!,
              fit: BoxFit.cover,
              // Hiển thị chữ cái đầu trong lúc tải ảnh, tránh vòng tròn trống.
              fadeInDuration: const Duration(milliseconds: 250),
              placeholder: (context, url) => Container(
                color: effectiveBgColor,
                alignment: Alignment.center,
                child: Text(
                  initialLetter,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: effectiveFontSize,
                    color: effectiveTextColor,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: effectiveBgColor,
                alignment: Alignment.center,
                child: Text(
                  initialLetter,
                  style: GoogleFonts.beVietnamPro(
                    fontWeight: FontWeight.bold,
                    fontSize: effectiveFontSize,
                    color: effectiveTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
