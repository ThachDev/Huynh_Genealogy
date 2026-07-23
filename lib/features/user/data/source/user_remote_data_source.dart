import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/domain/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity> getUserProfile();
  Future<UserEntity> updateUserProfile(UserEntity profile);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserEntity> getUserProfile() async {
    try {
      final response = await dio.get('${AppConstants.authEndpoint}/me');
      final responseData = _parseMapResponse(response.data);
      final rawData = responseData['data'] ?? responseData;
      if (rawData is Map<String, dynamic>) {
        return UserEntity.fromJson(rawData);
      }
      throw const ServerException(
        message: 'Dữ liệu phản hồi không hợp lệ',
        statusCode: null,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  @override
  Future<UserEntity> updateUserProfile(UserEntity profile) async {
    try {
      final response = await dio.put(
        '${AppConstants.authEndpoint}/profile',
        data: profile.toJson(),
      );
      final responseData = _parseMapResponse(response.data);
      final rawData = responseData['data'] ?? responseData;
      if (rawData is Map<String, dynamic>) {
        return UserEntity.fromJson(rawData);
      }
      return profile;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  Map<String, dynamic> _parseMapResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const ServerException(
      message: 'Dữ liệu trả về không đúng định dạng',
      statusCode: null,
    );
  }
}
