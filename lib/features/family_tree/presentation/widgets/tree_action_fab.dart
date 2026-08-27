import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Floating Action Button có thể mở rộng menu thao tác nhanh trên Cây Gia Phả
class TreeActionFabWidget extends StatelessWidget {
  const TreeActionFabWidget({
    super.key,
    required this.fabKey,
    required this.showGenerationBadges,
    required this.onExportBook,
    required this.onGoToMyLocation,
    required this.onFitOverview,
    required this.onToggleGenerationBadges,
  });

  final GlobalKey<ExpandableFabState> fabKey;
  final bool showGenerationBadges;
  final VoidCallback onExportBook;
  final VoidCallback onGoToMyLocation;
  final VoidCallback onFitOverview;
  final VoidCallback onToggleGenerationBadges;

  Widget _buildFabActionItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.accent.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: label,
          backgroundColor: context.surface,
          elevation: 3,
          onPressed: () {
            final state = fabKey.currentState;
            if (state != null && state.isOpen) {
              state.toggle();
            }
            onTap();
          },
          child: Icon(
            icon,
            size: 18,
            color: iconColor ?? context.primary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ExpandableFab(
      key: fabKey,
      type: ExpandableFabType.up,
      distance: 60.0,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.black.withValues(alpha: 0.55),
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(LucideIcons.layers, size: 22),
        foregroundColor: Colors.white,
        backgroundColor: context.primary,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(LucideIcons.x, size: 22),
        foregroundColor: Colors.white,
        backgroundColor: context.primary,
        shape: const CircleBorder(),
      ),
      children: [
        _buildFabActionItem(
          context,
          label: l10n.exportFamilyTreeFile,
          icon: LucideIcons.bookOpen,
          onTap: onExportBook,
        ),
        _buildFabActionItem(
          context,
          label: l10n.myLocationOnTree,
          icon: LucideIcons.crosshair,
          onTap: onGoToMyLocation,
        ),
        _buildFabActionItem(
          context,
          label: l10n.treeOverviewTooltip,
          icon: LucideIcons.maximize2,
          onTap: onFitOverview,
        ),
        _buildFabActionItem(
          context,
          label: showGenerationBadges
              ? l10n.hideGenBadges
              : l10n.showGenBadges,
          icon: LucideIcons.tag,
          iconColor:
              showGenerationBadges ? context.primary : context.textSecondary,
          onTap: onToggleGenerationBadges,
        ),
      ],
    );
  }
}
