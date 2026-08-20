import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';

/// Data source xử lý các thao tác bảo mật tài khoản
/// (đổi mật khẩu, xoá tài khoản).
///
/// Không nuốt lỗi: ném [AppException] có kiểu để presentation layer xử lý
/// thông điệp thân thiện với người dùng.
class AccountRemoteDataSource {
  AccountRemoteDataSource({Dio? dio, fb.FirebaseAuth? firebaseAuth})
      : _dio = dio ?? DioClient.instance,
        _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final Dio _dio;
  final fb.FirebaseAuth _firebaseAuth;

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) {
      throw const AuthException(message: 'Phiên đăng nhập đã hết hạn');
    }

    final idToken = await fbUser.getIdToken();
    if (idToken == null) {
      throw const AuthException(message: 'Không lấy được token phiên đăng nhập');
    }

    final response = await _post(
      AppConstants.changePasswordEndpoint,
      data: {
        'idToken': idToken,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return true;
    }
    throw ServerException(message: _messageOf(response.data));
  }

  Future<bool> deleteAccount() async {
    final response = await _delete(AppConstants.deleteAccountEndpoint);

    if (response.statusCode == 200 && response.data['success'] == true) {
      return true;
    }
    throw ServerException(message: _messageOf(response.data));
  }

  Future<Response<dynamic>> _post(String url, {Object? data}) async {
    try {
      return await _dio.post(url, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<dynamic>> _delete(String url) async {
    try {
      return await _dio.delete(url);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppTimeoutException(message: _messageOf(e.response?.data));
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(message: _messageOf(e.response?.data));
      default:
        return ServerException(
          message: _messageOf(e.response?.data) ?? e.message,
          statusCode: e.response?.statusCode,
        );
    }
  }

  String? _messageOf(dynamic data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}