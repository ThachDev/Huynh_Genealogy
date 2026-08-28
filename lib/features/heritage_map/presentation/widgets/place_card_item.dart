import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/heritage_place_entity.dart';

class PlaceCardItem extends StatelessWidget {
  const PlaceCardItem({
    super.key,
    required this.place,
    this.isSelected = false,
    this.userLocation,
    required this.onTap,
    this.onViewDetail,
  });

  final HeritagePlaceEntity place;
  final bool isSelected;
  final LatLng? userLocation;
  final VoidCallback onTap;
  final VoidCallback? onViewDetail;

  String? _calculateDistance() {
    if (userLocation == null) return null;
    const distanceCalc = Distance();
    final meters = distanceCalc.as(
      LengthUnit.Meter,
      userLocation!,
      LatLng(place.latitude, place.longitude),
    );
    if (meters < 1000) {
      return '$meters m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _openGoogleMapsDirections(BuildContext context) async {
    final lat = place.latitude;
    final lng = place.longitude;
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = Uri.parse(
            'geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(place.name)})');
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.error(context, 'Không thể mở ứng dụng bản đồ');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = _calculateDistance();
    final tagInfo = _getTypeTag(place.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? context.accent
                : context.resolve(
                    Colors.black.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.1),
                  ),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: (isSelected ? context.accent : Colors.black).withValues(
                alpha: isSelected ? 0.25 : (context.isDarkMode ? 0.2 : 0.04),
              ),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail ảnh hoặc Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 72,
                height: 72,
                child: place.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: place.imageUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: context.surface,
                          child: const Center(
                            child: AppLoading(size: 32),
                          ),
                        ),
                        errorWidget: (_, __, ___) =>
                            _buildPlaceholderIcon(tagInfo),
                      )
                    : _buildPlaceholderIcon(tagInfo),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin địa điểm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppBadge(
                        label: tagInfo.label,
                        color: tagInfo.color,
                      ),
                      if (place.generation != null) ...[
                        const SizedBox(width: 6),
                        AppBadge(
                          label: 'Đời ${place.generation}',
                          color: context.accent,
                        ),
                      ],
                      const Spacer(),
                      if (distance != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.navigation,
                                size: 12, color: context.primary),
                            const SizedBox(width: 3),
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
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Tên địa điểm
                  Text(
                    place.name,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Chỉ dẫn mốc hoặc Địa chỉ
                  if (place.landmarkGuide != null &&
                      place.landmarkGuide!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(LucideIcons.compass,
                            size: 12, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.landmarkGuide!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ] else if (place.address != null &&
                      place.address!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(LucideIcons.mapPin,
                            size: 12, color: context.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.address!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 8),

                  // Hàng nút hành động nhanh (Dùng AppButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        label: 'Chỉ đường',
                        prefixIcon:
                            const Icon(LucideIcons.navigation2, size: 13),
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.outline,
                        onPressed: () => _openGoogleMapsDirections(context),
                      ),
                      if (onViewDetail != null) ...[
                        const SizedBox(width: 8),
                        AppButton(
                          label: 'Chi tiết',
                          size: AppButtonSize.small,
                          onPressed: onViewDetail,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon(_TypeTag tag) {
    return Container(
      color: tag.color.withValues(alpha: 0.12),
      child: Center(
        child: Icon(tag.icon, color: tag.color, size: 28),
      ),
    );
  }

  _TypeTag _getTypeTag(HeritagePlaceType type) {
    switch (type) {
      case HeritagePlaceType.ancestralHouse:
        return const _TypeTag(
            'Nhà thờ họ', Color(0xFFD97706), LucideIcons.landmark);
      case HeritagePlaceType.patriarchTomb:
        return const _TypeTag(
            'Lăng mộ tổ', Color(0xFF8B5CF6), LucideIcons.crown);
      case HeritagePlaceType.memberGrave:
        return const _TypeTag(
            'Mộ tiền nhân', Color(0xFFE11D48), LucideIcons.flame);
      case HeritagePlaceType.shrine:
        return const _TypeTag(
            'Miếu / Đình', Color(0xFF059669), LucideIcons.building);
      case HeritagePlaceType.unknown:
        return const _TypeTag('Địa điểm', Colors.grey, LucideIcons.mapPin);
    }
  }
}

class _TypeTag {
  const _TypeTag(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;
}
