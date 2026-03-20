import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_family_tree/components/theme/app_theme.dart';
import 'package:app_family_tree/components/app_bar/app_bar.dart';
import 'package:app_family_tree/features/tree/presentation/widgets/tree_background_painter.dart';
import 'package:resources/resources.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      appBar: CommonAppBar(titleText: S.of(context).event, centerTitle: true),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: TreeBackgroundPainter()),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_note_rounded,
                  size: 64,
                  color: AppColors.gold.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).event,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).featureInDevelopment,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
