import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/core/data/model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> cacheCredentials({
    required String email,
    required String password,
  });
  Future<Map<String, String>?> getCachedCredentials();
  Future<void> clearCredentials();

  Future<void> cacheToken(String token, DateTime expiry);
  Future<({String token, DateTime expiry})?> getCachedToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    try {
      final jsonString = json.encode(userToCache.toJson());
      await secureStorage.write(
        key: AppConstants.cachedUser,
        value: jsonString,
      );
    } catch (e) {
      throw CacheException(
          message:
              AppLanguage.current?.errCacheCredentials ?? 'Lỗi ghi nhớ thông tin đăng nhập');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = await secureStorage.read(key: AppConstants.cachedUser);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw CacheException(
          message:
              AppLanguage.current?.errReadCredentials ?? 'Lỗi đọc thông tin đăng nhập đã lưu');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: AppConstants.cachedUser);
    } catch (e) {
      throw CacheException(
          message: AppLanguage.current?.errDeleteCredentials ?? 'Lỗi xoá thông tin đăng nhập');
    }
  }

  @override
  Future<void> cacheCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final encoded = base64Url.encode(utf8.encode('$email::$password'));
      await secureStorage.write(
        key: AppConstants.cachedCredentials,
        value: encoded,
      );
    } catch (e) {
      throw CacheException(
          message: AppLanguage.current?.errSavePassword ?? 'Lỗi ghi nhớ mật khẩu');
    }
  }

  @override
  Future<Map<String, String>?> getCachedCredentials() async {
    try {
      final encoded = await secureStorage.read(key: AppConstants.cachedCredentials);
      if (encoded == null) return null;
      final decoded = utf8.decode(base64Url.decode(encoded));
      final parts = decoded.split('::');
      if (parts.length != 2) return null;
      return {'email': parts[0], 'password': parts[1]};
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCredentials() async {
    try {
      await secureStorage.delete(key: AppConstants.cachedCredentials);
    } catch (e) {
      throw CacheException(
          message:
              AppLanguage.current?.errDeleteStoredCredentials ?? 'Lỗi xoá thông tin đăng nhập đã lưu');
    }
  }

  @override
  Future<void> cacheToken(String token, DateTime expiry) async {
    try {
      final jsonString = json.encode({
        'token': token,
        'expiry': expiry.toIso8601String(),
      });
      await secureStorage.write(
        key: AppConstants.cachedToken,
        value: jsonString,
      );
    } catch (e) {
      throw CacheException(
          message:
              AppLanguage.current?.errCacheCredentials ?? 'Lỗi lưu thông tin đăng nhập');
    }
  }

  @override
  Future<({String token, DateTime expiry})?> getCachedToken() async {
    try {
      final raw = await secureStorage.read(key: AppConstants.cachedToken);
      if (raw == null) return null;
      final map = json.decode(raw) as Map<String, dynamic>;
      final token = map['token'] as String?;
      final expiryStr = map['expiry'] as String?;
      if (token == null || expiryStr == null) return null;
      return (token: token, expiry: DateTime.parse(expiryStr));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await secureStorage.delete(key: AppConstants.cachedToken);
    } catch (e) {
      throw CacheException(
          message:
              AppLanguage.current?.errCacheCredentials ?? 'Lỗi xoá thông tin đăng nhập');
    }
  }
}
