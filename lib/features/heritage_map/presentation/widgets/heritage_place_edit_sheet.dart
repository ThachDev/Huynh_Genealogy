import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/heritage_place_entity.dart';
import 'heritage_sheet_wrapper.dart';

/// Bottom Sheet cho chế độ ghim / chỉnh sửa vị trí địa điểm (Edit / Pinning Mode).
///
/// Chỉ chịu trách nhiệm form chọn loại, nhập mô tả, và lưu vị trí.
class HeritagePlaceEditSheet extends StatelessWidget {
  const HeritagePlaceEditSheet({
    super.key,
    this.place,
    required this.pinnedLocation,
    required this.landmarkGuideController,
    required this.pinnedType,
    required this.onTypeChanged,
    this.isAssigningGrave = false,
    this.isEditing = false,
    this.isSaving = false,
    required this.onClose,
    required this.onSave,
  });

  final HeritagePlaceEntity? place;
  final LatLng pinnedLocation;
  final TextEditingController landmarkGuideController;
  final HeritagePlaceType pinnedType;
  final ValueChanged<HeritagePlaceType> onTypeChanged;
  final bool isAssigningGrave;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback onClose;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return HeritageSheetWrapper(
      onClose: onClose,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loc = pinnedLocation;
    final isMemberGrave = isAssigningGrave ||
        (place != null &&
            (place!.memberId != null ||
                place!.type == HeritagePlaceType.memberGrave));

    final displayName = place?.displayName ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Avatar + Column(Tên + Tọa độ GPS)
        Row(
          children: [
            if (displayName.isNotEmpty) ...[
              AppAvatar(
                avatarUrl: place?.memberAvatarUrl,
                fullName: displayName,
                radius: 19,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayName.isNotEmpty) ...[
                    Text(
                      displayName,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                  ],
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin,
                          size: 13, color: context.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          MapUtils.formatCoordinates(loc),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 2. Các thẻ phân loại địa điểm
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: HeritagePlaceType.values
                .where((t) => t != HeritagePlaceType.unknown)
                .map((type) => Padding(
                      padding: EdgeInsets.only(
                        right: type != HeritagePlaceType.shrine ? 6.0 : 0,
                      ),
                      child: _PlaceTypeChip(
                        type: type,
                        isSelected: pinnedType == type,
                        onTap: () => onTypeChanged(type),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),

        // 3. Mô tả / Chỉ dẫn tìm vị trí
        AppOutlineTextField(
          controller: landmarkGuideController,
          label: l10n.heritageMapLocationDescLabel,
          hintText: l10n.heritageMapLocationDescHint,
          maxLines: 2,
        ),
        const SizedBox(height: 14),

        // 4. Nút Lưu & Hủy
        Row(
          children: [
            Expanded(
              flex: 4,
              child: OutlinedButton(
                onPressed: isSaving ? null : onClose,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: context.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.heritageMapCancel,
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 13,
                    color: context.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: AppButton(
                label: isMemberGrave
                    ? l10n.heritageMapSaveGraveLocation
                    : (isEditing
                        ? l10n.heritageMapSaveChanges
                        : l10n.heritageMapSavePlace),
                prefixIcon:
                    const Icon(LucideIcons.check, size: 16, color: Colors.white),
                isLoading: isSaving,
                onPressed: isSaving ? null : onSave,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Chip chọn loại địa điểm trong Edit mode.
class _PlaceTypeChip extends StatelessWidget {
  const _PlaceTypeChip({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final HeritagePlaceType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shortLabel = type.getShortLabel(l10n);

    return Semantics(
      label: l10n.heritageMapSemanticsSelectType(shortLabel),
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? context.primary : context.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.primary
                  : context.accent.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type.icon,
                size: 13,
                color: isSelected ? Colors.white : type.color,
              ),
              const SizedBox(width: 4),
              Text(
                shortLabel,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
