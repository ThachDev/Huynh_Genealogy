import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
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
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    try {
      final jsonString = json.encode(userToCache.toJson());
      await sharedPreferences.setString(AppConstants.cachedUser, jsonString);
    } catch (e) {
      throw const CacheException(message: 'Lỗi ghi nhớ thông tin đăng nhập');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.cachedUser);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw const CacheException(message: 'Lỗi đọc thông tin đăng nhập đã lưu');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(AppConstants.cachedUser);
    } catch (e) {
      throw const CacheException(message: 'Lỗi xoá thông tin đăng nhập');
    }
  }

  @override
  Future<void> cacheCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final encoded = base64Url.encode(utf8.encode('$email::$password'));
      await sharedPreferences.setString(AppConstants.cachedCredentials, encoded);
    } catch (e) {
      throw const CacheException(message: 'Lỗi ghi nhớ mật khẩu');
    }
  }

  @override
  Future<Map<String, String>?> getCachedCredentials() async {
    try {
      final encoded = sharedPreferences.getString(AppConstants.cachedCredentials);
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
      await sharedPreferences.remove(AppConstants.cachedCredentials);
    } catch (e) {
      throw const CacheException(message: 'Lỗi xoá thông tin đăng nhập đã lưu');
    }
  }
}
