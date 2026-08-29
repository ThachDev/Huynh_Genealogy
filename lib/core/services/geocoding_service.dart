import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

/// Kết quả trả về từ dịch vụ tìm kiếm địa danh (Geocoding)
class GeocodingResult {
  const GeocodingResult({
    required this.name,
    required this.location,
  });

  final String name;
  final LatLng location;
}

/// Dịch vụ tìm kiếm tọa độ từ tên địa danh (sử dụng OpenStreetMap Nominatim)
class GeocodingService {
  GeocodingService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Tìm kiếm danh sách địa danh phù hợp với từ khóa [query]
  Future<List<GeocodingResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    try {
      final url =
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(trimmed)}&format=json&limit=5&countrycodes=vn';
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
