import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/theme_extensions.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final List<Widget>? trailing;
  final ValueChanged<String>? onChanged;
  final double? height;

  const AppSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.trailing,
    this.onChanged,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final h = height ?? 40.0;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return SearchBar(
          controller: controller,
          hintText: hintText,
          onChanged: onChanged,
          constraints: BoxConstraints(
            minHeight: h,
            maxHeight: h,
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 4.0),
            child: Icon(
              LucideIcons.search,
              size: 18,
              color: context.textSecondary,
            ),
          ),
          trailing: [
            if (value.text.isNotEmpty)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  LucideIcons.x,
                  size: 18,
                  color: context.textSecondary,
                ),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              ),
            if (trailing != null) ...trailing!,
          ],
          elevation: const WidgetStatePropertyAll(0.5),
          backgroundColor: WidgetStatePropertyAll(
            context.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.inter(
              fontSize: 13.5,
              color: context.textPrimary,
            ),
          ),
          hintStyle: WidgetStatePropertyAll(
            GoogleFonts.inter(
              fontSize: 13.5,
              color: context.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        );
      },
    );
  }
}
