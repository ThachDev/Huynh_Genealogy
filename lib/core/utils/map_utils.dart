import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/app_localizations.dart';
import '../widgets/widgets.dart';

/// Tiện ích liên quan đến bản đồ: tính khoảng cách, mở chỉ đường, copy tọa độ.
class MapUtils {
  MapUtils._();

  /// Định dạng tọa độ GPS chuẩn 6 chữ số thập phân.
  static String formatCoordinates(LatLng loc) {
    return '${loc.latitude.toStringAsFixed(6)}, ${loc.longitude.toStringAsFixed(6)}';
  }

  /// Tính khoảng cách giữa 2 điểm, trả về chuỗi dễ đọc (m / km).
  static String? calculateDistance(LatLng? from, LatLng? to) {
    if (from == null || to == null) return null;
    const distanceCalc = Distance();
    final meters = distanceCalc.as(LengthUnit.Meter, from, to);
    if (meters < 1000) {
      return '$meters m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// Mở Google Maps chỉ đường đến tọa độ [lat], [lng].
  static Future<void> openGoogleMapsDirections(
    BuildContext context, {
    required double lat,
    required double lng,
    String? placeName,
  }) async {
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
    );
    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        final label = placeName != null ? Uri.encodeComponent(placeName) : '';
        final fallbackUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng($label)');
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        AppSnackBar.error(context, l10n.heritageMapCannotOpenGoogleMaps);
      }
    }
  }

  /// Copy tọa độ kèm tên (nếu có) vào clipboard, hiển thị snackbar xác nhận.
  static void copyCoordinates(
    BuildContext context, {
    required LatLng location,
    String? name,
  }) {
    final l10n = AppLocalizations.of(context);
    final coordText = formatCoordinates(location);
    final text = name != null
        ? '$name\n${l10n.heritageMapCoordinatesClipboard(coordText)}'
        : coordText;
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.info(context, l10n.heritageMapCopiedCoordinates);
  }
}
