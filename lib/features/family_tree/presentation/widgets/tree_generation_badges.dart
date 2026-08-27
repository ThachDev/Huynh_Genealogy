import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import 'tree_edge_painter.dart';

/// Huy hiệu đời/thế hệ cố định ở mép trái màn hình, di chuyển mượt mà theo toạ độ Y của canvas
class TreeGenerationBadgesWidget extends StatelessWidget {
  const TreeGenerationBadgesWidget({
    super.key,
    required this.transformationController,
    required this.generationLevels,
    required this.viewportHeight,
  });

  final TransformationController transformationController;
  final Map<int, double> generationLevels;
  final double viewportHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: transformationController,
      builder: (context, _) {
        final matrix = transformationController.value;
        final sortedGens = generationLevels.keys.toList()..sort();

        return Stack(
          clipBehavior: Clip.none,
          children: sortedGens.map((gen) {
            final canvasY = generationLevels[gen]!;
            final screenY =
                MatrixUtils.transformPoint(matrix, Offset(0, canvasY)).dy;

            // Ẩn badge nếu nằm ngoài khung nhìn màn hình
            if (screenY < -30 || screenY > viewportHeight + 30) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: 14,
              top: screenY - 7,
              child: Text(
                l10n
                    .generationLevelFormat(TreeEdgePainter.toRoman(gen))
                    .toUpperCase(),
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: context.accent,
                  letterSpacing: 0.8,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
