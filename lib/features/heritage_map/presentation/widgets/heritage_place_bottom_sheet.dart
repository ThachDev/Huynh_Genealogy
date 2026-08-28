import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/heritage_place_entity.dart';

/// Bottom Sheet hợp nhất hiển thị chi tiết địa điểm (View Mode)
/// hoặc chỉnh sửa / ghim địa điểm mới (Edit / Pinning Mode)
class HeritagePlaceBottomSheet extends StatelessWidget {
  const HeritagePlaceBottomSheet({
    super.key,
    // 1. Chế độ xem (View Mode)
    this.place,
    this.userLocation,
    this.canEdit = false,
    required this.onClose,
    this.onEdit,
    this.onDelete,

    // 2. Chế độ ghim / chỉnh sửa (Pinning / Edit Mode)
    this.isPinningMode = false,
    this.pinnedLocation,
    this.landmarkGuideController,
    this.pinnedType,
    this.onTypeChanged,
    this.isAssigningGrave = false,
    this.isEditing = false,
    this.isSaving = false,
    this.onSave,
  });

  /// Factory cho chế độ xem chi tiết
  const factory HeritagePlaceBottomSheet.view({
    Key? key,
    required HeritagePlaceEntity place,
    LatLng? userLocation,
    bool canEdit,
    required VoidCallback onClose,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) = _HeritagePlaceBottomSheetView;

  /// Factory cho chế độ ghim / sửa vị trí trực tiếp
  const factory HeritagePlaceBottomSheet.edit({
    Key? key,
    HeritagePlaceEntity? place,
    required LatLng pinnedLocation,
    required TextEditingController landmarkGuideController,
    required HeritagePlaceType pinnedType,
    required ValueChanged<HeritagePlaceType> onTypeChanged,
    bool isAssigningGrave,
    bool isEditing,
    bool isSaving,
    required VoidCallback onClose,
    required VoidCallback onSave,
  }) = _HeritagePlaceBottomSheetEdit;

  final HeritagePlaceEntity? place;
  final LatLng? userLocation;
  final bool canEdit;
  final VoidCallback onClose;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  final bool isPinningMode;
  final LatLng? pinnedLocation;
  final TextEditingController? landmarkGuideController;
  final HeritagePlaceType? pinnedType;
  final ValueChanged<HeritagePlaceType>? onTypeChanged;
  final bool isAssigningGrave;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback? onSave;

  String? _calculateDistance() {
    if (userLocation == null || place == null) return null;
    const distanceCalc = Distance();
    final meters = distanceCalc.as(
      LengthUnit.Meter,
      userLocation!,
      LatLng(place!.latitude, place!.longitude),
    );
    if (meters < 1000) {
      return '$meters m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  Future<void> _openGoogleMapsDirections(BuildContext context) async {
    if (place == null) return;
    final lat = place!.latitude;
    final lng = place!.longitude;
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = Uri.parse(
            'geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(place!.name)})');
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.error(context, 'Không thể mở ứng dụng bản đồ Google Maps');
      }
    }
  }

  void _copyCoordinates(BuildContext context, {LatLng? customLoc}) {
    final loc = customLoc ??
        (place != null ? LatLng(place!.latitude, place!.longitude) : null);
    if (loc == null) return;
    final text = place != null
        ? '${place!.name}\nTọa độ: ${loc.latitude}, ${loc.longitude}'
        : '${loc.latitude}, ${loc.longitude}';
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.info(context, 'Đã sao chép tọa độ');
  }

  (IconData, String, Color) _getPlaceTypeInfo(HeritagePlaceType type) {
    switch (type) {
      case HeritagePlaceType.ancestralHouse:
        return (LucideIcons.landmark, 'Nhà thờ họ', const Color(0xFFD97706));
      case HeritagePlaceType.patriarchTomb:
        return (LucideIcons.crown, 'Lăng mộ tổ', const Color(0xFF8B5CF6));
      case HeritagePlaceType.memberGrave:
        return (LucideIcons.flame, 'Mộ tiền nhân', const Color(0xFFE11D48));
      case HeritagePlaceType.shrine:
        return (LucideIcons.building, 'Miếu / Đình', const Color(0xFF059669));
      case HeritagePlaceType.unknown:
        return (LucideIcons.mapPin, 'Địa điểm', Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: context.accent.withValues(alpha: 0.15),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Nút đóng 'X'
            Align(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: context.textSecondary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: 19,
                      color: context.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // 2. Nội dung: Chế độ Xem (View) hoặc Chế độ Chỉnh sửa / Ghim (Edit)
            if (isPinningMode)
              _buildPinningContent(context)
            else if (place != null)
              _buildViewContent(context),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VIEW MODE CONTENT
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildViewContent(BuildContext context) {
    final targetPlace = place!;
    final distance = _calculateDistance();
    final typeInfo = _getPlaceTypeInfo(targetPlace.type);
    final rawName = (targetPlace.memberFullName != null &&
            targetPlace.memberFullName!.trim().isNotEmpty)
        ? targetPlace.memberFullName!.trim()
        : targetPlace.name.trim();
    final displayName = rawName.startsWith(RegExp(r'^[Mm]ộ\s+'))
        ? rawName.replaceFirst(RegExp(r'^[Mm]ộ\s+'), '')
        : rawName;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar + Tên địa điểm + Khoảng cách GPS
        Row(
          children: [
            AppAvatar(
              avatarUrl: targetPlace.memberAvatarUrl,
              fullName: targetPlace.memberFullName ?? targetPlace.name,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              Icon(typeInfo.$1, size: 14, color: typeInfo.$3),
              const SizedBox(width: 5),
              Text(
                typeInfo.$2,
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
                '${targetPlace.latitude.toStringAsFixed(6)}, ${targetPlace.longitude.toStringAsFixed(6)}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => _copyCoordinates(context),
                child: Icon(LucideIcons.copy, size: 13, color: context.primary),
              ),
            ],
          ),
        ),

        // Chỉ dẫn thực địa (nếu có)
        if (targetPlace.landmarkGuide != null &&
            targetPlace.landmarkGuide!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: context.textSecondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.accent.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.compass, size: 13, color: context.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    targetPlace.landmarkGuide!,
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
          ),
        ],

        const SizedBox(height: 14),

        // Hàng nút thao tác kiểu Google Maps
        Row(
          children: [
            // Nút Chỉ đường
            Expanded(
              child: AppButton(
                label: 'Chỉ đường',
                prefixIcon: const Icon(LucideIcons.navigation2, size: 14),
                size: AppButtonSize.small,
                onPressed: () => _openGoogleMapsDirections(context),
              ),
            ),
            const SizedBox(width: 8),

            // Nút Sao chép tọa độ
            OutlinedButton(
              onPressed: () => _copyCoordinates(context),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(
                  color: context.textSecondary.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(LucideIcons.share2,
                  size: 14, color: context.textPrimary),
            ),

            // Nút Admin Sửa / Xóa
            if (canEdit) ...[
              const SizedBox(width: 6),
              if (onEdit != null)
                IconButton(
                  icon: Icon(LucideIcons.edit3,
                      size: 16, color: context.textSecondary),
                  tooltip: 'Chỉnh sửa',
                  visualDensity: VisualDensity.compact,
                  onPressed: onEdit,
                ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(LucideIcons.trash2,
                      size: 16, color: Colors.redAccent),
                  tooltip: 'Xóa địa điểm',
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                ),
            ],
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PINNING / EDIT MODE CONTENT
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildPinningContent(BuildContext context) {
    final loc = pinnedLocation ??
        (place != null ? LatLng(place!.latitude, place!.longitude) : null);

    final isMemberGrave = isAssigningGrave ||
        (place != null &&
            (place!.memberId != null ||
                place!.type == HeritagePlaceType.memberGrave));

    final rawName = place?.memberFullName ?? place?.name ?? '';
    final displayName = rawName.startsWith(RegExp(r'^[Mm]ộ\s+'))
        ? rawName.replaceFirst(RegExp(r'^[Mm]ộ\s+'), '')
        : rawName;

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
                  if (loc != null)
                    Row(
                      children: [
                        Icon(LucideIcons.mapPin,
                            size: 13, color: context.primary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${loc.latitude.toStringAsFixed(6)}, ${loc.longitude.toStringAsFixed(6)}',
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

        // 3. Các thẻ phân loại địa điểm luôn hiển thị để người dùng chọn
        if (pinnedType != null && onTypeChanged != null) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildPinnedTypeChip(
                  context,
                  type: HeritagePlaceType.ancestralHouse,
                  icon: LucideIcons.landmark,
                  iconColor: const Color(0xFFD97706),
                  label: 'Nhà thờ',
                ),
                const SizedBox(width: 6),
                _buildPinnedTypeChip(
                  context,
                  type: HeritagePlaceType.patriarchTomb,
                  icon: LucideIcons.crown,
                  iconColor: const Color(0xFF8B5CF6),
                  label: 'Mộ tổ',
                ),
                const SizedBox(width: 6),
                _buildPinnedTypeChip(
                  context,
                  type: HeritagePlaceType.memberGrave,
                  icon: LucideIcons.flame,
                  iconColor: const Color(0xFFE11D48),
                  label: 'Mộ tiền nhân',
                ),
                const SizedBox(width: 6),
                _buildPinnedTypeChip(
                  context,
                  type: HeritagePlaceType.shrine,
                  icon: LucideIcons.building,
                  iconColor: const Color(0xFF059669),
                  label: 'Miếu / Đình',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],

        // 3. Mô tả / Chỉ dẫn tìm vị trí
        if (landmarkGuideController != null)
          AppOutlineTextField(
            controller: landmarkGuideController!,
            label: 'Mô tả vị trí & chỉ dẫn.',
            hintText: 'VD: Nằm cạnh cây đa, rẽ ngõ thứ 2 bên phải...',
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
                  'Hủy',
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
                    ? 'Lưu vị trí mộ'
                    : (isEditing ? 'Lưu thay đổi' : 'Lưu địa điểm'),
                prefixIcon: const Icon(LucideIcons.check,
                    size: 16, color: Colors.white),
                isLoading: isSaving,
                onPressed: isSaving ? null : onSave,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPinnedTypeChip(
    BuildContext context, {
    required HeritagePlaceType type,
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    final isSelected = pinnedType == type;
    return GestureDetector(
      onTap: () => onTypeChanged?.call(type),
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
              icon,
              size: 13,
              color: isSelected ? Colors.white : iconColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeritagePlaceBottomSheetView extends HeritagePlaceBottomSheet {
  const _HeritagePlaceBottomSheetView({
    super.key,
    required super.place,
    super.userLocation,
    super.canEdit,
    required super.onClose,
    super.onEdit,
    super.onDelete,
  }) : super(isPinningMode: false);
}

class _HeritagePlaceBottomSheetEdit extends HeritagePlaceBottomSheet {
  const _HeritagePlaceBottomSheetEdit({
    super.key,
    super.place,
    required super.pinnedLocation,
    required super.landmarkGuideController,
    required super.pinnedType,
    required super.onTypeChanged,
    super.isAssigningGrave,
    super.isEditing,
    super.isSaving,
    required super.onClose,
    required super.onSave,
  }) : super(isPinningMode: true);
}
