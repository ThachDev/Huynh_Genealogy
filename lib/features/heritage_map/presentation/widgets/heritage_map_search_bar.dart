import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/services/geocoding_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../resources/app_localizations.dart';
import '../../domain/entities/heritage_place_entity.dart';

/// Thanh tìm kiếm trên cùng kiểu Google Maps
///
/// Hỗ trợ cả 2 chế độ:
/// - Overview Mode: Tìm kiếm địa điểm dòng họ trong gia phả (với danh sách gợi ý rơi xuống)
/// - Pinning Mode: Tìm kiếm địa danh OpenStreetMap kèm dropdown gợi ý
class HeritageMapSearchBar extends StatelessWidget {
  const HeritageMapSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onBack,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onClear,
    this.isSearching = false,
    this.placeSuggestions = const [],
    this.onSelectPlace,
    this.geocodingResults = const [],
    this.onSelectGeocodeResult,
    this.userLocation,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final VoidCallback onBack;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool isSearching;
  final List<HeritagePlaceEntity> placeSuggestions;
  final ValueChanged<HeritagePlaceEntity>? onSelectPlace;
  final List<GeocodingResult> geocodingResults;
  final ValueChanged<GeocodingResult>? onSelectGeocodeResult;
  final LatLng? userLocation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasPlaceSuggestions = placeSuggestions.isNotEmpty;
    final hasGeocodeResults = geocodingResults.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // 1. Nút Back
            Semantics(
              label: l10n.heritageMapBack,
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  color: context.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    LucideIcons.arrowLeft,
                    color: context.textPrimary,
                    size: 20,
                  ),
                  tooltip: l10n.heritageMapBack,
                  onPressed: onBack,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 2. Ô nhập tìm kiếm
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: context.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: 18,
                      color: context.primary,
                    ),
                    suffixIcon: isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : (controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(LucideIcons.x, size: 16),
                                onPressed: onClear,
                              )
                            : null),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                  ),
                  onTap: onTap,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              ),
            ),
          ],
        ),

        // 3. Dropdown gợi ý địa điểm dòng họ (Overview Mode)
        if (hasPlaceSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: placeSuggestions.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: context.textSecondary.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, idx) {
                final place = placeSuggestions[idx];
                final distance = MapUtils.calculateDistance(
                  userLocation,
                  LatLng(place.latitude, place.longitude),
                );

                return ListTile(
                  dense: true,
                  leading: AppAvatar(
                    avatarUrl: place.memberAvatarUrl,
                    fullName: place.displayName,
                    radius: 16,
                  ),
                  title: Text(
                    place.displayName,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      Icon(
                        place.type.icon,
                        size: 11,
                        color: place.type.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.type.getLabel(l10n),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: context.textSecondary,
                        ),
                      ),
                      if (distance != null) ...[
                        Text(
                          ' • $distance',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Icon(
                    LucideIcons.arrowUpLeft,
                    size: 16,
                    color: context.textSecondary.withValues(alpha: 0.5),
                  ),
                  onTap: () => onSelectPlace?.call(place),
                );
              },
            ),
          ),

        // 4. Dropdown gợi ý địa danh Nominatim (Pinning Mode)
        if (hasGeocodeResults)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              color: context.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: geocodingResults.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final item = geocodingResults[idx];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    LucideIcons.mapPin,
                    size: 16,
                    color: context.primary,
                  ),
                  title: Text(
                    item.name,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: context.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => onSelectGeocodeResult?.call(item),
                );
              },
            ),
          ),
      ],
    );
  }
}
