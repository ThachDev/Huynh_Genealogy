import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/wish_entity.dart';
import '../../domain/wish_reaction.dart';

abstract class WishRemoteDataSource {
  Future<List<WishEntity>> getWishesByMember(int memberId);
  Future<List<WishEntity>> getMyWishes({int? memberId});
  Future<WishEntity> createWish(WishEntity wish);
  Future<WishReaction> reactToWish(int wishId);
  Future<bool> reportWish(int wishId, String reason);
  Future<bool> markWishAsRead(int wishId);
  Future<bool> markAllWishesAsRead();
}

class WishRemoteDataSourceImpl implements WishRemoteDataSource {
  WishRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<WishEntity>> getWishesByMember(int memberId) async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/wishes/member/$memberId',
      );
      final data = response.data;
      if (data != null && data['success'] == true) {
        final List list = data['data'] ?? [];
        return list.map((e) => WishEntity.fromJson(e)).toList();
      }
      throw ServerException(
        message: 'Phản hồi server không hợp lệ',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<WishEntity>> getMyWishes({int? memberId}) async {
    try {
      final endpoint = memberId != null
          ? '${AppConstants.baseUrl}/wishes/member/$memberId'
          : '${AppConstants.baseUrl}/wishes/my-wishes';
      final response = await dio.get(endpoint);
      final data = response.data;
      if (data != null && data['success'] == true) {
        final List list = data['data'] ?? [];
        return list.map((e) => WishEntity.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (memberId != null) {
        try {
          final fallback = await dio.get('${AppConstants.baseUrl}/wishes/member/$memberId');
          final data = fallback.data;
          if (data != null && data['success'] == true) {
            final List list = data['data'] ?? [];
            return list.map((e) => WishEntity.fromJson(e)).toList();
          }
        } catch (_) {}
      }
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WishEntity> createWish(WishEntity wish) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/wishes',
        data: wish.toJson(),
      );
      final data = response.data;
      if (data != null && data['success'] == true) {
        return WishEntity.fromJson(data['data']);
      }
      throw ServerException(
        message: 'Tạo lời chúc thất bại',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WishReaction> reactToWish(int wishId) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/wishes/$wishId/react',
      );
      final data = response.data;
      if (data != null && data['success'] == true) {
        final reactionData = data['data'] as Map<String, dynamic>;
        return WishReaction(
          reactionCount: (reactionData['reactionCount'] as num?)?.toInt() ??
              (reactionData['reaction_count'] as num?)?.toInt() ??
              0,
          reacted: reactionData['reacted'] == true ||
              reactionData['isReacted'] == true ||
              reactionData['reacted'] == 1,
        );
      }
      throw ServerException(
        message: 'React thất bại',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> reportWish(int wishId, String reason) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/reports',
        data: {
          'targetType': 'wish',
          'targetId': wishId,
          'reason': reason,
        },
      );
      final data = response.data;
      if (data != null && data['success'] == true) {
        return true;
      }
      throw ServerException(
        message: 'Báo cáo thất bại',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> markWishAsRead(int wishId) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/wishes/$wishId/read',
      );
      final data = response.data;
      return data != null && data['success'] == true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> markAllWishesAsRead() async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/wishes/read-all',
      );
      final data = response.data;
      return data != null && data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}