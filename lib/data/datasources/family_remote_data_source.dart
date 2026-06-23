import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/branch_model.dart';
import '../models/member_model.dart';
import '../models/family_model.dart';
import '../models/family_user_model.dart';

abstract class FamilyRemoteDataSource {
  Future<List<MemberModel>> getMembers({int? branchId});
  Future<MemberModel> getMemberById(int id);
  Future<MemberModel> saveMember(MemberModel member);
  Future<bool> deleteMember(int id);

  Future<List<BranchModel>> getBranches();
  Future<BranchModel> getBranchById(int id);
  Future<BranchModel> saveBranch(BranchModel branch);
  Future<bool> deleteBranch(int id);

  // ---------- Family & Onboarding ----------
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
}

class FamilyRemoteDataSourceImpl implements FamilyRemoteDataSource {
  final Dio dio;

  FamilyRemoteDataSourceImpl({required this.dio});

  // ─── Members ──────────────────────────────────────────────────────────────

  @override
  Future<List<MemberModel>> getMembers({int? branchId}) async {
    try {
      final queryParams = branchId != null ? {'branchId': branchId} : null;
      final response = await dio.get(
        AppConstants.membersEndpoint,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => MemberModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<MemberModel> getMemberById(int id) async {
    try {
      final response =
          await dio.get('${AppConstants.membersEndpoint}/$id');
      return MemberModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundException(message: 'Không tìm thấy thành viên');
      }
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<MemberModel> saveMember(MemberModel member) async {
    try {
      final isNew = member.id == 0;
      final response = isNew
          ? await dio.post(
              AppConstants.membersEndpoint,
              data: member.toJson(),
            )
          : await dio.put(
              '${AppConstants.membersEndpoint}/${member.id}',
              data: member.toJson(),
            );
      return MemberModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi lưu thành viên',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> deleteMember(int id) async {
    try {
      await dio.delete('${AppConstants.membersEndpoint}/$id');
      return true;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi xoá thành viên',
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ─── Branches ─────────────────────────────────────────────────────────────

  @override
  Future<List<BranchModel>> getBranches() async {
    try {
      final response = await dio.get(AppConstants.branchesEndpoint);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<BranchModel> getBranchById(int id) async {
    try {
      final response =
          await dio.get('${AppConstants.branchesEndpoint}/$id');
      return BranchModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundException(message: 'Không tìm thấy chi/nhánh');
      }
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<BranchModel> saveBranch(BranchModel branch) async {
    try {
      final isNew = branch.id == 0;
      final response = isNew
          ? await dio.post(
              AppConstants.branchesEndpoint,
              data: branch.toJson(),
            )
          : await dio.put(
              '${AppConstants.branchesEndpoint}/${branch.id}',
              data: branch.toJson(),
            );
      return BranchModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi lưu chi/nhánh',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> deleteBranch(int id) async {
    try {
      await dio.delete('${AppConstants.branchesEndpoint}/$id');
      return true;
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi xoá chi/nhánh',
        statusCode: e.response?.statusCode,
      );
    }
  }

  // ─── Family & Onboarding ──────────────────────────────────────────────────

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
}
