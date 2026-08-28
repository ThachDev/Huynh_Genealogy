import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/heritage_place_model.dart';

abstract class HeritagePlaceRemoteDataSource {
  Future<List<HeritagePlaceModel>> getHeritagePlaces({
    required int familyId,
    String? type,
    int? generation,
    String? query,
  });

  Future<HeritagePlaceModel> getHeritagePlaceById({
    required int familyId,
    required int placeId,
  });

  Future<HeritagePlaceModel?> getMemberGrave({
    required int familyId,
    required int memberId,
  });

  Future<HeritagePlaceModel> saveHeritagePlace(HeritagePlaceModel place);

  Future<bool> deleteHeritagePlace({
    required int familyId,
    required int placeId,
  });
}

class HeritagePlaceRemoteDataSourceImpl
    implements HeritagePlaceRemoteDataSource {
  HeritagePlaceRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<HeritagePlaceModel>> getHeritagePlaces({
    required int familyId,
    String? type,
    int? generation,
    String? query,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/$familyId/heritage-places',
        queryParameters: {
          if (type != null && type.isNotEmpty) 'type': type,
          if (generation != null) 'generation': generation,
          if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
        },
      );

      final data = response.data;
      if (data != null) {
        final List list = data is List
            ? data
            : (data['data'] is List ? data['data'] as List : []);
        return list
            .map((e) => HeritagePlaceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : (e.message ?? 'Lỗi kết nối máy chủ khi lấy danh sách di tích & mộ phần');
      throw ServerException(message: message!, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<HeritagePlaceModel> getHeritagePlaceById({
    required int familyId,
    required int placeId,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/$familyId/heritage-places/$placeId',
      );
      final data = response.data;
      if (data != null && data['data'] != null) {
        return HeritagePlaceModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      throw const ServerException(message: 'Không tìm thấy thông tin địa điểm');
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : (e.message ?? 'Lỗi máy chủ khi lấy thông tin chi tiết di tích');
      throw ServerException(message: message!, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<HeritagePlaceModel?> getMemberGrave({
    required int familyId,
    required int memberId,
  }) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/$familyId/members/$memberId/grave',
      );
      final data = response.data;
      if (data != null && data['data'] != null) {
        return HeritagePlaceModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      final message = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : (e.message ?? 'Lỗi khi tra cứu vị trí mộ phần');
      throw ServerException(message: message!, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<HeritagePlaceModel> saveHeritagePlace(HeritagePlaceModel place) async {
    try {
      if (place.id > 0) {
        // Cập nhật địa điểm đã có (PUT)
        final response = await dio.put(
          '${AppConstants.familiesEndpoint}/${place.familyId}/heritage-places/${place.id}',
          data: place.toJson(),
        );
        final data = response.data;
        if (data != null && data['data'] != null) {
          return HeritagePlaceModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        return place;
      } else {
        // Thêm mới địa điểm (POST)
        final response = await dio.post(
          '${AppConstants.familiesEndpoint}/${place.familyId}/heritage-places',
          data: place.toJson(),
        );
        final data = response.data;
        if (data != null && data['data'] != null) {
          return HeritagePlaceModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        throw const ServerException(message: 'Không nhận được dữ liệu phản hồi sau khi tạo');
      }
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : (e.message ?? 'Lỗi khi lưu thông tin địa điểm / mộ phần');
      throw ServerException(message: message!, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> deleteHeritagePlace({
    required int familyId,
    required int placeId,
  }) async {
    try {
      final response = await dio.delete(
        '${AppConstants.familiesEndpoint}/$familyId/heritage-places/$placeId',
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response?.data['message'] != null
          ? e.response?.data['message'].toString()
          : (e.message ?? 'Lỗi khi xóa địa điểm');
      throw ServerException(message: message!, statusCode: e.response?.statusCode);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
