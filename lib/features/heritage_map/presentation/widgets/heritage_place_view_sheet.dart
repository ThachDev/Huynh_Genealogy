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

/// Bottom Sheet hiển thị chi tiết một địa điểm di sản (View Mode).
///
/// Chỉ chịu trách nhiệm hiển thị thông tin + hành động xem.
/// Business logic (khoảng cách, chỉ đường, copy) uỷ quyền cho [MapUtils].
class HeritagePlaceViewSheet extends StatelessWidget {
  const HeritagePlaceViewSheet({
    super.key,
    required this.place,
    this.userLocation,
    this.canEdit = false,
    required this.onClose,
    this.onEdit,
    this.onDelete,
  });

  final HeritagePlaceEntity place;
  final LatLng? userLocation;
  final bool canEdit;
  final VoidCallback onClose;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return HeritageSheetWrapper(
      onClose: onClose,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final distance = MapUtils.calculateDistance(
      userLocation,
      LatLng(place.latitude, place.longitude),
    );
    final displayName = place.displayName;
    final placeType = place.type;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar + Tên + Khoảng cách GPS
        Row(
          children: [
            AppAvatar(
              avatarUrl: place.memberAvatarUrl,
              fullName: place.memberFullName ?? place.name,
              radius: 19,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayName,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (distance != null) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.navigation,
                        size: 11, color: context.primary),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: context.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        // Phân loại | Tọa độ GPS + Copy
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              Icon(placeType.icon, size: 14, color: placeType.color),
              const SizedBox(width: 5),
              Text(
                placeType.getLabel(l10n),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '|',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Icon(LucideIcons.mapPin, size: 13, color: context.textSecondary),
              const SizedBox(width: 4),
              Text(
                MapUtils.formatCoordinates(
                    LatLng(place.latitude, place.longitude)),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Semantics(
                label: l10n.heritageMapSemanticsCopyCoordinates,
                button: true,
                child: InkWell(
                  onTap: () => MapUtils.copyCoordinates(
                    context,
                    location: LatLng(place.latitude, place.longitude),
                    name: place.name,
                  ),
                  child:
                      Icon(LucideIcons.copy, size: 13, color: context.primary),
                ),
              ),
            ],
          ),
        ),

        // Chỉ dẫn thực địa (nếu có)
        if (place.landmarkGuide != null &&
            place.landmarkGuide!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(LucideIcons.compass, size: 14, color: context.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  place.landmarkGuide!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 14),

        // Hàng nút thao tác
        Row(
          children: [
            // Nút Chỉ đường
            Expanded(
              child: AppButton(
                label: l10n.heritageMapDirections,
                prefixIcon: const Icon(LucideIcons.navigation2, size: 14),
                size: AppButtonSize.small,
                onPressed: () => MapUtils.openGoogleMapsDirections(
                  context,
                  lat: place.latitude,
                  lng: place.longitude,
                  placeName: place.name,
                ),
              ),
            ),

            // Nút Admin Sửa / Xóa
            if (canEdit) ...[
              const SizedBox(width: 8),
              if (onEdit != null)
                Semantics(
                  label: l10n.heritageMapSemanticsEditPlace,
                  button: true,
                  child: IconButton(
                    icon: Icon(LucideIcons.edit3,
                        size: 16, color: context.textSecondary),
                    tooltip: l10n.heritageMapEdit,
                    visualDensity: VisualDensity.compact,
                    onPressed: onEdit,
                  ),
                ),
              if (onDelete != null)
                Semantics(
                  label: l10n.heritageMapSemanticsDeletePlace,
                  button: true,
                  child: IconButton(
                    icon: const Icon(LucideIcons.trash2,
                        size: 16, color: Colors.redAccent),
                    tooltip: l10n.heritageMapDeletePlace,
                    visualDensity: VisualDensity.compact,
                    onPressed: onDelete,
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }
}
