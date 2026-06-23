import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
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
}
