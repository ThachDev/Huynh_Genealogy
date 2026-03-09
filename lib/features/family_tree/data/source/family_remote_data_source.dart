import 'package:dio/dio.dart';
import 'package:app_family_tree/config/app_constants.dart';
import 'package:app_family_tree/exception_handler/exceptions.dart';
import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';

abstract class FamilyRemoteDataSource {
  Future<List<MemberModel>> getMembers({int? branchId});
  Future<MemberModel> getMemberById(int id);
  Future<MemberModel> saveMember(MemberModel member);
  Future<bool> deleteMember(int id);

  Future<List<BranchModel>> getBranches();
  Future<BranchModel> getBranchById(int id);
  Future<BranchModel> saveBranch(BranchModel branch);
  Future<bool> deleteBranch(int id);
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
}






