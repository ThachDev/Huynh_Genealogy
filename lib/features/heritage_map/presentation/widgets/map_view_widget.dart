import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/entities/heritage_place_entity.dart';

class MapViewWidget extends StatelessWidget {
  const MapViewWidget({
    super.key,
    required this.mapController,
    required this.places,
    this.selectedPlace,
    this.isSatellite = false,
    this.userLocation,
    required this.onSelectPlace,
    this.onMapTap,
  });

  final MapController mapController;
  final List<HeritagePlaceEntity> places;
  final HeritagePlaceEntity? selectedPlace;
  final bool isSatellite;
  final LatLng? userLocation;
  final ValueChanged<HeritagePlaceEntity> onSelectPlace;
  final void Function(LatLng point)? onMapTap;

  @override
  Widget build(BuildContext context) {
    // Tọa độ trung tâm mặc định (Hà Tĩnh / Việt Nam)
    final defaultCenter = places.isNotEmpty
        ? LatLng(places.first.latitude, places.first.longitude)
        : (userLocation ?? const LatLng(21.028511, 105.854444));

    final markers = <Marker>[];

    // 1. Marker các địa điểm di tích / mộ phần
    for (final place in places) {
      markers.add(
        Marker(
          point: LatLng(place.latitude, place.longitude),
          width: 44,
          height: 44,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => onSelectPlace(place),
            child: _buildPlaceMarkerIcon(context, place),
          ),
        ),
      );
    }

    // 2. Marker vị trí người dùng (nếu có)
    if (userLocation != null) {
      markers.add(
        Marker(
          point: userLocation!,
          width: 28,
          height: 28,
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.5),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: defaultCenter,
        initialZoom: 14.5,
        minZoom: 4.0,
        maxZoom: 19.0,
        onTap: (tapPosition, point) {
          if (onMapTap != null) {
            onMapTap!(point);
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: isSatellite
              ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
              : 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
          userAgentPackageName: 'com.giatocviet.app',
          maxZoom: 19,
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
  Widget _buildPlaceMarkerIcon(
    BuildContext context,
    HeritagePlaceEntity place,
  ) {
    IconData icon;
    Color bgColor;

    switch (place.type) {
      case HeritagePlaceType.ancestralHouse:
        icon = LucideIcons.landmark;
        bgColor = const Color(0xFFD97706); // Vàng hổ phách
        break;
      case HeritagePlaceType.patriarchTomb:
        icon = LucideIcons.crown;
        bgColor = const Color(0xFF8B5CF6); // Tím hoàng gia
        break;
      case HeritagePlaceType.memberGrave:
        icon = LucideIcons.flame;
        bgColor = const Color(0xFFE11D48); // Đỏ son
        break;
      case HeritagePlaceType.shrine:
        icon = LucideIcons.building;
        bgColor = const Color(0xFF059669); // Xanh ngọc
        break;
      case HeritagePlaceType.unknown:
        icon = LucideIcons.mapPin;
        bgColor = Colors.grey;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.5),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
