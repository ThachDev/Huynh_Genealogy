import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:giatocviet/core/data/model/branch_model.dart';
import 'package:giatocviet/core/data/model/member_model.dart';

abstract class UserTreeRemoteDataSource {
  Future<List<MemberModel>> getMembers({int? branchId});
  Future<MemberModel> getMemberById(int id);
  Future<MemberModel> saveMember(MemberModel member);
  Future<bool> deleteMember(int id);

  Future<List<BranchModel>> getBranches();
  Future<BranchModel> getBranchById(int id);
  Future<BranchModel> saveBranch(BranchModel branch);
  Future<bool> deleteBranch(int id);
}

class UserTreeRemoteDataSourceImpl implements UserTreeRemoteDataSource {
  final Dio dio;

  UserTreeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MemberModel>> getMembers({int? branchId}) async {
    try {
      final queryParams = branchId != null ? {'branchId': branchId} : null;
      final response = await dio.get(
        AppConstants.membersEndpoint,
        queryParameters: queryParams,
      );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final List<dynamic> data = responseData['data'] as List<dynamic>;
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
      final response = await dio.get('${AppConstants.membersEndpoint}/$id');
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      return MemberModel.fromJson(responseData['data'] as Map<String, dynamic>);
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
      final jsonMap = member.toJson();

      // Clean up null values to prevent sending them as string "null" in FormData
      // Also omit 'id' if it is 0 (new member) to avoid backend interpreting it as an update
      final Map<String, dynamic> cleanMap = {};
      jsonMap.forEach((key, value) {
        if (value != null && (key != 'id' || value != 0)) {
          cleanMap[key] = value;
        }
      });

      dynamic dataPayload = cleanMap;

      final avatarUrl = member.avatarUrl;
      if (avatarUrl != null &&
          avatarUrl.isNotEmpty &&
          !avatarUrl.startsWith('http') &&
          !avatarUrl.startsWith('https')) {
        final file = File(avatarUrl);
        if (file.existsSync()) {
          final Map<String, dynamic> formDataMap = Map.from(cleanMap);
          formDataMap['avatar'] = await MultipartFile.fromFile(
            avatarUrl,
            filename: avatarUrl.split('/').last,
          );
          formDataMap.remove('avatarUrl');
          dataPayload = FormData.fromMap(formDataMap);
        } else {
          final Map<String, dynamic> finalMap = Map.from(cleanMap);
          finalMap.remove('avatarUrl');
          dataPayload = finalMap;
        }
      }

      final response = isNew
          ? await dio.post(
              AppConstants.membersEndpoint,
              data: dataPayload,
            )
          : await dio.put(
              '${AppConstants.membersEndpoint}/${member.id}',
              data: dataPayload,
            );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic rawData = responseData['data'];
      if (rawData is Map<String, dynamic>) {
        return MemberModel.fromJson(rawData);
      } else if (rawData is List &&
          rawData.isNotEmpty &&
          rawData.first is Map) {
        return MemberModel.fromJson(rawData.first as Map<String, dynamic>);
      }
      // Fallback: re-fetch member by id when update returns non-object (e.g. [1])
      final fallbackResponse = await dio.get(
        '${AppConstants.membersEndpoint}/${member.id}',
      );
      final fallbackData = fallbackResponse.data as Map<String, dynamic>;
      return MemberModel.fromJson(fallbackData['data'] as Map<String, dynamic>);
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

  @override
  Future<List<BranchModel>> getBranches() async {
    try {
      final response = await dio.get(AppConstants.branchesEndpoint);
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final List<dynamic> data = responseData['data'] as List<dynamic>;
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
      final response = await dio.get('${AppConstants.branchesEndpoint}/$id');
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      return BranchModel.fromJson(responseData['data'] as Map<String, dynamic>);
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
      final jsonMap = branch.toJson();

      // Lọc null và loại bỏ id=0 (tạo mới)
      final Map<String, dynamic> cleanMap = {};
      jsonMap.forEach((key, value) {
        if (value != null && (key != 'id' || value != 0)) {
          cleanMap[key] = value;
        }
      });

      final response = isNew
          ? await dio.post(
              AppConstants.branchesEndpoint,
              data: cleanMap,
            )
          : await dio.put(
              '${AppConstants.branchesEndpoint}/${branch.id}',
              data: cleanMap,
            );
      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final dynamic rawData = responseData['data'];
      if (rawData is Map<String, dynamic>) {
        return BranchModel.fromJson(rawData);
      }
      // Fallback: re-fetch branch by id when update returns non-object
      final fallbackResponse = await dio.get(
        '${AppConstants.branchesEndpoint}/${branch.id}',
      );
      final fallbackData = fallbackResponse.data as Map<String, dynamic>;
      return BranchModel.fromJson(fallbackData['data'] as Map<String, dynamic>);
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
