import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:giatocviet/core/data/model/member_model.dart';
import '../../../../core/data/model/family_model.dart';
import '../../../../core/data/model/family_user_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<FamilyModel> createFamily({
    required String name,
    String? description,
    String? coverImageUrl,
    required int userId,
  });

  Future<Map<String, dynamic>> verifyInviteCode(String code);

  Future<FamilyUserModel> joinFamily({
    required int userId,
    required int familyId,
    int? memberNodeId,
  });

  Future<List<FamilyUserModel>> getPendingRequests(int familyId);

  Future<bool> approveRequest(int requestId);

  Future<bool> rejectRequest(int requestId);

  Future<FamilyModel> getFamilyDetail(int familyId);
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final Dio dio;

  OnboardingRemoteDataSourceImpl({required this.dio});

  @override
  Future<FamilyModel> createFamily({
    required String name,
    String? description,
    String? coverImageUrl,
    required int userId,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.familiesEndpoint,
        data: {
          'name': name,
          'description': description,
          'coverImageUrl': coverImageUrl,
          'userId': userId,
        },
      );
      return FamilyModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi tạo dòng họ',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> verifyInviteCode(String code) async {
    try {
      final response = await dio.get(
        AppConstants.verifyCodeEndpoint,
        queryParameters: {'code': code},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final family = FamilyModel.fromJson(data['family'] as Map<String, dynamic>);
      final members = (data['members'] as List<dynamic>)
          .map((json) => MemberModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return {
        'family': family,
        'members': members,
      };
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi xác nhận mã mời',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<FamilyUserModel> joinFamily({
    required int userId,
    required int familyId,
    int? memberNodeId,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.joinFamilyEndpoint,
        data: {
          'userId': userId,
          'familyId': familyId,
          'memberNodeId': memberNodeId,
        },
      );
      return FamilyUserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi gửi yêu cầu gia nhập',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<FamilyUserModel>> getPendingRequests(int familyId) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/requests',
        queryParameters: {'familyId': familyId},
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((json) => FamilyUserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi tải yêu cầu gia nhập',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> approveRequest(int requestId) async {
    try {
      final response = await dio.put(
        '${AppConstants.familiesEndpoint}/requests/$requestId/approve',
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi phê duyệt yêu cầu',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> rejectRequest(int requestId) async {
    try {
      final response = await dio.put(
        '${AppConstants.familiesEndpoint}/requests/$requestId/reject',
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi từ chối yêu cầu',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<FamilyModel> getFamilyDetail(int familyId) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/$familyId',
      );
      return FamilyModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi tải thông tin dòng họ',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
