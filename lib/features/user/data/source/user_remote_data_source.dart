import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/domain/entity/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserEntity> getUserProfile();
  Future<UserEntity> updateUserProfile(UserEntity profile);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {

  UserRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<UserEntity> getUserProfile() async {
    try {
      final response = await dio.get('${AppConstants.authEndpoint}/me');
      final responseData = _parseMapResponse(response.data);
      final rawData = responseData['data'] ?? responseData;
      if (rawData is Map<String, dynamic>) {
        return UserEntity.fromJson(rawData);
      }
      throw ServerException(
        message: AppLanguage.current?.errInvalidResponseData ??
            'Dữ liệu phản hồi không hợp lệ',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? AppLanguage.current?.errServerConnection ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
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
        message: e.message ?? AppLanguage.current?.errServerConnection ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }

  Map<String, dynamic> _parseMapResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw ServerException(
      message: AppLanguage.current?.errInvalidDataFormat ??
          'Dữ liệu trả về không đúng định dạng',
    );
  }
}
