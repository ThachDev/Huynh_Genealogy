import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../config/app_config.dart';
import '../di/injection_container.dart';

/// Kết quả trả về từ dịch vụ tìm kiếm địa danh (Geocoding)
class GeocodingResult {
  const GeocodingResult({
    required this.name,
    required this.location,
  });

  final String name;
  final LatLng location;
}

/// Dịch vụ tìm kiếm tọa độ từ tên địa danh
///
/// Hỗ trợ:
/// 1. **Backend Geocoding Proxy API** (Cloudflare KV Cache 7 ngày + Ẩn API Key)
/// 2. **Google Maps Geocoding API** (Gọi trực tiếp nếu có API Key ở client)
/// 3. **OpenStreetMap Nominatim** (Fallback tự động khi mất mạng/lỗi)
class GeocodingService {
  GeocodingService({
    Dio? dio,
    String? googleMapsApiKey,
  })  : _dio = dio ?? (sl.isRegistered<Dio>() ? sl<Dio>() : Dio()),
        _googleMapsApiKey = googleMapsApiKey ?? AppConfig.googleMapsApiKey;

  final Dio _dio;
  final String _googleMapsApiKey;

  /// Tìm kiếm danh sách địa danh phù hợp với từ khóa [query]
  Future<List<GeocodingResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    // 1. Ưu tiên gọi Backend Proxy API (có Cache Cloudflare KV 7 ngày)
    final backendResults = await _searchBackendApi(trimmed);
    if (backendResults.isNotEmpty) {
      return backendResults;
    }

    // 2. Dự phòng gọi trực tiếp Google Maps API nếu client có cấu hình Key
    if (_googleMapsApiKey.isNotEmpty) {
      final googleResults = await _searchGoogleMaps(trimmed);
      if (googleResults.isNotEmpty) {
        return googleResults;
      }
    }

    // 3. Fallback cuối cùng sang OpenStreetMap Nominatim miễn phí
    return _searchNominatim(trimmed);
  }

  /// Tìm kiếm qua Backend API Proxy (`/api/geocoding/search?q=...`)
  Future<List<GeocodingResult>> _searchBackendApi(String query) async {
    try {
      const url = '${AppConfig.baseUrl}/geocoding/search';
      final response = await _dio.get(
        url,
        queryParameters: {'q': query},
        options: Options(
          sendTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is List) {
          return data.map((item) {
            final lat =
                double.tryParse(item['latitude']?.toString() ?? '0') ?? 0.0;
            final lng =
                double.tryParse(item['longitude']?.toString() ?? '0') ?? 0.0;
            final name = item['name']?.toString() ?? '';
            return GeocodingResult(name: name, location: LatLng(lat, lng));
          }).toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Tìm kiếm qua Google Maps Geocoding API
  Future<List<GeocodingResult>> _searchGoogleMaps(String query) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&components=country:VN&language=vi&key=$_googleMapsApiKey';
      final response = await _dio.get(
        url,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.data is Map<String, dynamic>) {
        final status = response.data['status']?.toString();
        if (status == 'OK' && response.data['results'] is List) {
          final results = response.data['results'] as List;
          return results.map((item) {
            final loc = item['geometry']?['location'];
            final lat = double.tryParse(loc?['lat']?.toString() ?? '0') ?? 0.0;
            final lng = double.tryParse(loc?['lng']?.toString() ?? '0') ?? 0.0;
            final name = item['formatted_address']?.toString() ?? '';
            return GeocodingResult(name: name, location: LatLng(lat, lng));
          }).toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Tìm kiếm qua OpenStreetMap Nominatim (Free Fallback)
  Future<List<GeocodingResult>> _searchNominatim(String query) async {
    try {
      final url =
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5&countrycodes=vn';
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'User-Agent': 'GiaTocViet-FamilyApp/1.0'},
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.data is List) {
        return (response.data as List).map((item) {
          final lat = double.tryParse(item['lat']?.toString() ?? '0') ?? 0.0;
          final lon = double.tryParse(item['lon']?.toString() ?? '0') ?? 0.0;
          final name = item['display_name']?.toString() ?? '';
          return GeocodingResult(name: name, location: LatLng(lat, lon));
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
