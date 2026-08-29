import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/entities/heritage_place_entity.dart';

/// Bản đồ chuyên dụng cho chế độ Ghim / Chọn vị trí (Pinning Mode)
class HeritagePinningMapView extends StatelessWidget {
  const HeritagePinningMapView({
    super.key,
    required this.mapController,
    required this.pinnedLocation,
    required this.referencePlaces,
    required this.isSatellite,
    required this.onMapTap,
  });

  final MapController mapController;
  final LatLng pinnedLocation;
  final List<HeritagePlaceEntity> referencePlaces;
  final bool isSatellite;
  final void Function(LatLng point) onMapTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: pinnedLocation,
        initialZoom: 16.5,
        minZoom: 4.0,
        maxZoom: 19.0,
        onTap: (_, point) => onMapTap(point),
      ),
      children: [
        // 1. Tầng gạch bản đồ (Giao thông / Vệ tinh)
        TileLayer(
          urlTemplate: isSatellite
              ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
              : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.giatocviet.app',
          maxZoom: 19,
        ),

        // 2. Tầng Marker
        MarkerLayer(
          markers: [
            // Các địa điểm đã có sẵn để người dùng dễ tham chiếu xung quanh
            ...referencePlaces.map((p) {
              return Marker(
                point: LatLng(p.latitude, p.longitude),
                width: 32,
                height: 32,
                child: const Opacity(
                  opacity: 0.6,
                  child: Icon(
                    LucideIcons.mapPin,
                    color: Colors.amber,
                    size: 28,
                  ),
                ),
              );
            }),

            // Marker điểm ghim đang chọn (màu đỏ nổi bật)
            Marker(
              point: pinnedLocation,
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
    );
  }
}
