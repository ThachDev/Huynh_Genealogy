import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/heritage_place_entity.dart';

/// Thanh cuộn ngang các chip lọc danh mục địa điểm di tích kiểu Google Maps
class HeritageMapFilterBar extends StatelessWidget {
  const HeritageMapFilterBar({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final HeritagePlaceType? selectedType;
  final ValueChanged<HeritagePlaceType?> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final placeTypes = HeritagePlaceType.values
        .where((t) => t != HeritagePlaceType.unknown)
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          // 1. Chip "Tất cả"
          _buildChip(
            context: context,
            label: l10n.heritageMapFilterAll,
            icon: LucideIcons.layers,
            iconColor: context.textSecondary,
            isSelected: selectedType == null,
            onTap: () => onTypeSelected(null),
          ),
          const SizedBox(width: 6),

          // 2. Các chip theo từng loại địa điểm di tích
          ...placeTypes.map((type) {
            final isSelected = selectedType == type;
            final label = type.getLabel(l10n);
            return Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: _buildChip(
                context: context,
                label: label,
                icon: type.icon,
                iconColor: type.color,
                isSelected: isSelected,
                onTap: () => onTypeSelected(type),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? context.primary : context.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isSelected
                  ? context.primary
                  : context.accent.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : iconColor,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : context.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
