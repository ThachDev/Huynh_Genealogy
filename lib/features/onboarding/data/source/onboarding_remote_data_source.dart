import 'package:dio/dio.dart';
import 'dart:io';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import 'package:giatocviet/features/family_tree/data/models/member_model.dart';
import '../../../../features/family_tree/data/models/family_model.dart';
import '../../../../core/data/model/family_user_model.dart';

/// ============================================================================
/// REMOTE DATA SOURCE — ONBOARDING FEATURE (REST API INTERFACE)
/// ============================================================================
/// Khai báo các phương thức gọi REST API trực tiếp đến Backend server.
/// ============================================================================
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
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? placeOfBirth,
    String? maritalStatus,
    String? education,
    String? avatarUrl,
    int? parentId,
    int? spouseId,
    String? notes,
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

/// ============================================================================
/// REMOTE DATA SOURCE IMPLEMENTATION (REST API CALLS WITH DIO)
/// ============================================================================
/// Thực thi gọi API bằng thư viện `Dio`.
/// Xử lý Multipart/FormData đối với file ảnh và chuẩn hóa Exception khi có lỗi.
/// ============================================================================
class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {

  OnboardingRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  /// --------------------------------------------------------------------------
  /// API 1: POST /api/v1/families (Tạo dòng họ mới)
  /// Phân loại: Xử lý cả JSON thông thường hoặc FormData nếu người dùng tải ảnh logo.
  /// --------------------------------------------------------------------------
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

      // Nếu logoUrl là đường dẫn file cục bộ (chưa upload lên server), chuyển sang FormData
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

      // Gửi HTTP POST request
      final response = await dio.post(
        AppConstants.familiesEndpoint,
        data: dataPayload,
      );

      // Map kết quả JSON (`response.data['data']`) sang Data Model `FamilyModel`
      return FamilyModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      // Ném ra ServerException để Repository tầng trên bắt và wrap thành Failure
      throw ServerException(
        message: _getErrorMessage(
            e, AppLanguage.current?.errCreateFamily ?? 'Lỗi tạo dòng họ'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errVerifyInviteCode ?? 'Lỗi xác nhận mã mời'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<FamilyUserModel> joinFamily({
    required int userId,
    required int familyId,
    int? memberNodeId,
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? placeOfBirth,
    String? maritalStatus,
    String? education,
    String? avatarUrl,
    int? parentId,
    int? spouseId,
    String? notes,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.joinFamilyEndpoint,
        data: {
          'userId': userId,
          'familyId': familyId,
          'memberNodeId': memberNodeId,
          if (fullName != null) 'fullName': fullName,
          if (gender != null) 'gender': gender,
          if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
          if (placeOfBirth != null) 'placeOfBirth': placeOfBirth,
          if (maritalStatus != null) 'maritalStatus': maritalStatus,
          if (education != null) 'education': education,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
          if (parentId != null) 'parentId': parentId,
          if (spouseId != null) 'spouseId': spouseId,
          if (notes != null) 'notes': notes,
        },
      );
      return FamilyUserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(
            e, AppLanguage.current?.errSendJoinRequest ?? 'Lỗi gửi yêu cầu gia nhập'),
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
      if (e.response?.statusCode == 403) {
        return [];
      }
      throw ServerException(
        message: _getErrorMessage(
            e, AppLanguage.current?.errLoadJoinRequest ?? 'Lỗi tải yêu cầu gia nhập'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errApproveRequest ?? 'Lỗi phê duyệt yêu cầu'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errRejectRequest ?? 'Lỗi từ chối yêu cầu'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errLoadFamilyInfo ?? 'Lỗi tải thông tin dòng họ'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errUpdateFamilyInfo ?? 'Lỗi cập nhật thông tin dòng họ'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errLoadMemberList ?? 'Lỗi tải danh sách thành viên'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errUpdateMemberRole ?? 'Lỗi phân quyền thành viên'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errDeleteFamily ?? 'Lỗi xóa dòng họ'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errLinkFamilyProfile ?? 'Lỗi liên kết hồ sơ gia phả'),
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
        message: _getErrorMessage(
            e, AppLanguage.current?.errTransferOwnership ?? 'Lỗi chuyển nhượng quyền Trưởng tộc'),
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
