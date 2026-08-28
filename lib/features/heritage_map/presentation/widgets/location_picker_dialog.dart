import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/widgets.dart';

class LocationPickerDialog extends StatefulWidget {
  const LocationPickerDialog({
    super.key,
    required this.initialLocation,
  });

  final LatLng initialLocation;

  static Future<LatLng?> show(
    BuildContext context, {
    required LatLng initialLocation,
  }) {
    return Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerDialog(initialLocation: initialLocation),
      ),
    );
  }

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  final MapController _mapController = MapController();
  late LatLng _currentSelectedPoint;
  bool _isSatellite = true; // Mặc định mở ảnh vệ tinh để dễ nhìn mốc ở làng quê
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _currentSelectedPoint = widget.initialLocation;
  }

  Future<void> _getCurrentGpsLocation() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) AppSnackBar.error(context, 'Bạn đã từ chối quyền truy cập vị trí');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) AppSnackBar.error(context, 'Quyền vị trí bị khóa vĩnh viễn trong Cài đặt');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newPoint = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _currentSelectedPoint = newPoint;
      });
      _mapController.move(newPoint, 17.0);

      if (mounted) {
        AppSnackBar.info(context, 'Đã lấy tọa độ GPS thực địa của bạn');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Không thể lấy tọa độ GPS: $e');
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppAppBar(
        title: 'Chọn vị trí trên bản đồ',
        actions: [
          IconButton(
            icon: Icon(
              _isSatellite ? LucideIcons.map : LucideIcons.satellite,
              color: context.textPrimary,
            ),
            tooltip: _isSatellite ? 'Xem bản đồ giao thông' : 'Xem ảnh vệ tinh',
            onPressed: () {
              setState(() => _isSatellite = !_isSatellite);
            },
          ),
        ],
      ),
      body: AppBackgroundBody(
        enableMaxWidth: false,
        child: Stack(
          children: [
          // 1. Bản đồ tương tác
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentSelectedPoint,
              initialZoom: 16.0,
              minZoom: 4.0,
              maxZoom: 19.0,
              onTap: (_, point) {
                setState(() {
                  _currentSelectedPoint = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.giatocviet.app',
                maxZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentSelectedPoint,
                    width: 52,
                    height: 52,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      LucideIcons.mapPin,
                      color: Colors.redAccent,
                      size: 48,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Banner hướng dẫn trên cùng
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, color: Colors.amberAccent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Chạm vào điểm bất kỳ trên bản đồ vệ tinh để cắm ghim vị trí ngôi mộ/di tích.',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Nút Lấy GPS thực địa nổi bên phải
          Positioned(
            right: 16,
            bottom: 110,
            child: Container(
              decoration: BoxDecoration(
                color: context.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: _isLocating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(LucideIcons.crosshair, color: context.primary, size: 22),
                tooltip: 'Lấy vị trí GPS hiện tại của tôi',
                onPressed: _isLocating ? null : _getCurrentGpsLocation,
              ),
            ),
          ),

          // 4. Thanh hiển thị tọa độ & Nút xác nhận dưới cùng
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.accent.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin, color: context.accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Tọa độ: ${_currentSelectedPoint.latitude.toStringAsFixed(6)}, ${_currentSelectedPoint.longitude.toStringAsFixed(6)}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Xác nhận vị trí này',
                    prefixIcon: const Icon(LucideIcons.check, size: 16, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context, _currentSelectedPoint);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
