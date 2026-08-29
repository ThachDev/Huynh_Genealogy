import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Container chung cho bottom sheet: bo góc, shadow, nút đóng.
/// Dùng cho cả View và Edit sheet để đảm bảo giao diện nhất quán.
class HeritageSheetWrapper extends StatelessWidget {
  const HeritageSheetWrapper({
    super.key,
    required this.onClose,
    required this.child,
  });

  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: context.accent.withValues(alpha: 0.15),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút đóng 'X'
            Align(
              alignment: Alignment.centerRight,
              child: Semantics(
                label: l10n.heritageMapSemanticsClose,
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: context.textSecondary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: 19,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Nội dung chính
            child,
          ],
        ),
      ),
    );
  }
}
