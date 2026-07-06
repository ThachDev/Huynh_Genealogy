import 'package:dio/dio.dart';
import 'dart:io';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:giatocviet/core/data/model/member_model.dart';
import '../../../../core/data/model/family_model.dart';
import '../../../../core/data/model/family_user_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<FamilyModel> createFamily({
    required String name,
    String? description,
    String? logoUrl,
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

  Future<FamilyModel> updateFamily({
    required int id,
    String? name,
    String? description,
    String? origin,
    String? logoUrl,
  });

  Future<List<FamilyUserModel>> getApprovedMembers(int familyId);

  Future<bool> updateMemberRole({
    required int familyId,
    required int userId,
    required String role,
  });

  Future<bool> deleteFamily(int familyId);

  Future<bool> linkMemberToUser({
    required int userId,
    required int memberId,
  });

  Future<bool> transferOwnership({
    required int familyId,
    required int newOwnerUserId,
  });
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final Dio dio;

  OnboardingRemoteDataSourceImpl({required this.dio});

  @override
  Future<FamilyModel> createFamily({
    required String name,
    String? description,
    String? logoUrl,
    required int userId,
  }) async {
    try {
      dynamic dataPayload = {
        'name': name,
        'description': description,
        'userId': userId,
      };

      if (logoUrl != null &&
          logoUrl.isNotEmpty &&
          !logoUrl.startsWith('http') &&
          !logoUrl.startsWith('https')) {
        final file = File(logoUrl);
        if (file.existsSync()) {
          final Map<String, dynamic> formDataMap = {
            'name': name,
            'description': description,
            'userId': userId,
            'avatar': await MultipartFile.fromFile(
              logoUrl,
              filename: logoUrl.split('/').last,
            ),
          };
          dataPayload = FormData.fromMap(formDataMap);
        }
      }

      final response = await dio.post(
        AppConstants.familiesEndpoint,
        data: dataPayload,
      );
      return FamilyModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi tạo dòng họ'),
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
        message: _getErrorMessage(e, 'Lỗi xác nhận mã mời'),
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
        message: _getErrorMessage(e, 'Lỗi gửi yêu cầu gia nhập'),
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
        message: _getErrorMessage(e, 'Lỗi tải yêu cầu gia nhập'),
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
        message: _getErrorMessage(e, 'Lỗi phê duyệt yêu cầu'),
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
        message: _getErrorMessage(e, 'Lỗi từ chối yêu cầu'),
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
        message: _getErrorMessage(e, 'Lỗi tải thông tin dòng họ'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<FamilyModel> updateFamily({
    required int id,
    String? name,
    String? description,
    String? origin,
    String? logoUrl,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        if (name != null) 'name': name,
        if (description != null) 'description': description,
        if (origin != null) 'origin': origin,
      };

      dynamic payload = dataMap;

      // Handle logo upload
      if (logoUrl != null && logoUrl.isNotEmpty) {
        if (!logoUrl.startsWith('http') && !logoUrl.startsWith('https')) {
          final file = File(logoUrl);
          if (file.existsSync()) {
            dataMap['avatar'] = await MultipartFile.fromFile(
              logoUrl,
              filename: logoUrl.split('/').last,
            );
          }
        } else {
          dataMap['logoUrl'] = logoUrl;
        }
      }

      if (dataMap.containsKey('avatar')) {
        payload = FormData.fromMap(dataMap);
      }

      final response = await dio.put(
        '${AppConstants.familiesEndpoint}/$id',
        data: payload,
      );
      return FamilyModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi cập nhật thông tin dòng họ'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<FamilyUserModel>> getApprovedMembers(int familyId) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/members',
        queryParameters: {'familyId': familyId},
      );
      final list = response.data['data'] as List<dynamic>;
      return list
          .map((item) => FamilyUserModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi tải danh sách thành viên'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> updateMemberRole({
    required int familyId,
    required int userId,
    required String role,
  }) async {
    try {
      final response = await dio.put(
        '${AppConstants.familiesEndpoint}/members/$userId/role',
        queryParameters: {'familyId': familyId},
        data: {'role': role},
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi phân quyền thành viên'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> deleteFamily(int familyId) async {
    try {
      final response = await dio.delete(
        '${AppConstants.familiesEndpoint}/$familyId',
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi xóa dòng họ'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> linkMemberToUser({
    required int userId,
    required int memberId,
  }) async {
    try {
      final response = await dio.patch(
        '${AppConstants.familiesEndpoint}/members/$userId/link-member',
        data: {'memberId': memberId},
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi liên kết hồ sơ gia phả'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> transferOwnership({
    required int familyId,
    required int newOwnerUserId,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.transferOwnershipEndpoint,
        data: {
          'familyId': familyId,
          'newOwnerUserId': newOwnerUserId,
        },
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e, 'Lỗi chuyển nhượng quyền Trưởng tộc'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  String _getErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return e.message ?? fallback;
  }
}
