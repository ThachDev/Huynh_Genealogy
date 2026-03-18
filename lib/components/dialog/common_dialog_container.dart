import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';

class CommonDialogContainer extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData? icon;
  final String statusLabel; // "MỚI" or "SỬA"
  final bool isDesktop;

  const CommonDialogContainer({
    super.key,
    required this.child,
    required this.title,
    this.icon,
    this.statusLabel = 'MỚI',
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            width: isDesktop ? 800 : double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              color: AppColors.parchment,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: AppColors.crimson, size: 28),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          title.toUpperCase(),
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.crimson,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.gold,
                  indent: 24,
                  endIndent: 24,
                ),

                // Content
                Flexible(child: child),
              ],
            ),
          ),

          // Diagonal Status Label
          Positioned(
            top: 12,
            right: -24,
            child: Transform.rotate(
              angle: 0.785, // ~ 45 degrees
              child: Container(
                width: 100,
                height: 22,
                color: AppColors.gold,
                alignment: Alignment.center,
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.crimson,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
