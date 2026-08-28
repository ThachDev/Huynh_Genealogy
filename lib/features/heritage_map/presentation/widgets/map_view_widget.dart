import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/theme_extensions.dart';
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
    this.onToggleLayer,
    this.onLocateMe,
    this.onMapTap,
    this.draggablePinLocation,
    this.onPinDragged,
    this.showControls = true,
  });

  final MapController mapController;
  final List<HeritagePlaceEntity> places;
  final HeritagePlaceEntity? selectedPlace;
  final bool isSatellite;
  final LatLng? userLocation;
  final ValueChanged<HeritagePlaceEntity> onSelectPlace;
  final VoidCallback? onToggleLayer;
  final VoidCallback? onLocateMe;
  final void Function(LatLng point)? onMapTap;
  final LatLng? draggablePinLocation;
  final ValueChanged<LatLng>? onPinDragged;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    // Tọa độ trung tâm mặc định (Hà Tĩnh / Việt Nam)
    final defaultCenter = places.isNotEmpty
        ? LatLng(places.first.latitude, places.first.longitude)
        : (userLocation ?? const LatLng(21.028511, 105.854444));

    final markers = <Marker>[];

    // 1. Marker các địa điểm di tích / mộ phần
    for (final place in places) {
      final isSelected = selectedPlace?.id == place.id;
      markers.add(
        Marker(
          point: LatLng(place.latitude, place.longitude),
          width: isSelected ? 52 : 44,
          height: isSelected ? 52 : 44,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () => onSelectPlace(place),
            child: _buildPlaceMarkerIcon(context, place, isSelected),
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

    // 3. Marker ghim kéo thả (Draggable Pin Marker trong màn hình chọn tọa độ)
    if (draggablePinLocation != null) {
      markers.add(
        Marker(
          point: draggablePinLocation!,
          width: 48,
          height: 48,
          alignment: Alignment.topCenter,
          child: const Icon(
            LucideIcons.mapPin,
            color: Colors.redAccent,
            size: 44,
            shadows: [
              Shadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
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
                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.giatocviet.app',
              maxZoom: 19,
            ),
            MarkerLayer(markers: markers),
          ],
        ),

        // Nút điều khiển bản đồ nổi (Lớp Vệ tinh, Định vị GPS)
        if (showControls)
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                if (onToggleLayer != null)
                  _buildFloatingButton(
                    context,
                    icon: isSatellite ? LucideIcons.map : LucideIcons.satellite,
                    tooltip: isSatellite ? 'Bản đồ giao thông' : 'Ảnh vệ tinh',
                    color: isSatellite ? context.accent : context.surface,
                    iconColor: isSatellite ? Colors.black : context.primary,
                    onTap: onToggleLayer!,
                  ),
                const SizedBox(height: 10),
                if (onLocateMe != null)
                  _buildFloatingButton(
                    context,
                    icon: LucideIcons.crosshair,
                    tooltip: 'Vị trí của tôi',
                    onTap: onLocateMe!,
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceMarkerIcon(
    BuildContext context,
    HeritagePlaceEntity place,
    bool isSelected,
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.amberAccent : Colors.white,
          width: isSelected ? 3.0 : 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: (isSelected ? Colors.amberAccent : bgColor).withValues(alpha: 0.6),
            blurRadius: isSelected ? 12 : 6,
            spreadRadius: isSelected ? 3 : 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: isSelected ? 24 : 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFloatingButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    Color? color,
    Color? iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? context.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? context.primary, size: 20),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }
}
