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
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: const _UserLocationRadarMarker(),
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

/// Widget hiển thị chấm xanh vị trí người dùng kiểu Google Maps với sóng radar lan toả liên tục
class _UserLocationRadarMarker extends StatefulWidget {
  const _UserLocationRadarMarker();

  @override
  State<_UserLocationRadarMarker> createState() =>
      _UserLocationRadarMarkerState();
}

class _UserLocationRadarMarkerState extends State<_UserLocationRadarMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );

    _opacityAnimation = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Sóng radar lan toả (Expanding Ripple Ring)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4285F4).withValues(alpha: 0.35),
                      border: Border.all(
                        color: const Color(0xFF4285F4),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // 2. Chấm xanh trung tâm chuẩn Google Maps (Blue Dot + White Border + Halo Glow)
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8), // Google Maps Blue
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A73E8).withValues(alpha: 0.5),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
