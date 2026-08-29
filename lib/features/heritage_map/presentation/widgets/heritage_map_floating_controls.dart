import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';

/// Cụm nút điều khiển nổi trên bản đồ (Chuyển layer Vệ tinh / Giao thông & GPS)
class HeritageMapFloatingControls extends StatelessWidget {
  const HeritageMapFloatingControls({
    super.key,
    required this.isSatellite,
    required this.isLocating,
    required this.onToggleLayer,
    required this.onLocateMe,
  });

  final bool isSatellite;
  final bool isLocating;
  final VoidCallback onToggleLayer;
  final VoidCallback onLocateMe;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final layerTooltip = isSatellite
        ? l10n.heritageMapLayerStreet
        : l10n.heritageMapLayerSatellite;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Nút Chuyển tầng Vệ tinh / Giao thông
        Semantics(
          label: layerTooltip,
          button: true,
          child: _buildFloatingCircleBtn(
            context: context,
            icon: isSatellite ? LucideIcons.map : LucideIcons.satellite,
            tooltip: layerTooltip,
            color: isSatellite ? context.accent : context.surface,
            iconColor: isSatellite ? Colors.black : context.textPrimary,
            onPressed: onToggleLayer,
          ),
        ),
        const SizedBox(height: 10),

        // 2. Nút Vị trí của tôi (GPS)
        Semantics(
          label: l10n.heritageMapMyCurrentLocation,
          button: true,
          child: _buildFloatingCircleBtn(
            context: context,
            icon: isLocating ? LucideIcons.loader2 : LucideIcons.crosshair,
            tooltip: l10n.heritageMapMyCurrentLocation,
            color: context.surface,
            iconColor: context.primary,
            isLoading: isLocating,
            onPressed: isLocating ? null : onLocateMe,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCircleBtn({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required Color color,
    required Color iconColor,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, color: iconColor, size: 20),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }
}
