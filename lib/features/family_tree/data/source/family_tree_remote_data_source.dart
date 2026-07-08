import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:giatocviet/core/data/model/branch_model.dart';
import 'package:giatocviet/core/data/model/member_model.dart';

abstract class FamilyTreeRemoteDataSource {
  Future<List<MemberModel>> getMembers({int? branchId, int? familyId});
  Future<MemberModel> getMemberById(int id);
  Future<MemberModel> saveMember(MemberModel member);
  Future<bool> deleteMember(int id);

  Future<List<BranchModel>> getBranches({int? familyId});
  Future<BranchModel> getBranchById(int id);
  Future<BranchModel> saveBranch(BranchModel branch);
  Future<bool> deleteBranch(int id);
}

class FamilyTreeRemoteDataSourceImpl implements FamilyTreeRemoteDataSource {
  final Dio dio;

  FamilyTreeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MemberModel>> getMembers({int? branchId, int? familyId}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (branchId != null) queryParams['branchId'] = branchId;
      if (familyId != null) queryParams['familyId'] = familyId;
      final response = await dio.get(
        AppConstants.membersEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final responseData = _parseMapResponse(response.data);
      final data = _parseListData(responseData);
      return data
          .map((json) => MemberModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  Map<String, dynamic> _parseMapResponse(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const ServerException(
      message: 'Dữ liệu trả về không đúng định dạng',
      statusCode: null,
    );
  }

  Map<String, dynamic> _parseMapData(Map<String, dynamic> responseData) {
    final raw = responseData['data'];
    if (raw is Map<String, dynamic>) return raw;
    throw const ServerException(
      message: 'Dữ liệu trả về không đúng định dạng',
      statusCode: null,
    );
  }

  List<dynamic> _parseListData(Map<String, dynamic> responseData) {
    final raw = responseData['data'];
    if (raw is List<dynamic>) return raw;
    throw const ServerException(
      message: 'Dữ liệu danh sách trả về không đúng định dạng',
      statusCode: null,
    );
  }

  @override
  Future<MemberModel> getMemberById(int id) async {
    try {
      final response = await dio.get('${AppConstants.membersEndpoint}/$id');
      final responseData = _parseMapResponse(response.data);
      return MemberModel.fromJson(_parseMapData(responseData));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundException(message: 'Không tìm thấy thành viên');
      }
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  @override
  Future<MemberModel> saveMember(MemberModel member) async {
    try {
      final isNew = member.id == 0;
      final jsonMap = member.toJson();

      // Keep null values so we can clear fields on the backend (e.g., unselect parent/spouse).
      // Also omit 'id' if it is 0 (new member) to avoid backend interpreting it as an update.
      final Map<String, dynamic> cleanMap = {};
      jsonMap.forEach((key, value) {
        if (value != null) {
          if (key == 'id' && value == 0) return;
          cleanMap[key] = value;
        } else {
          // Send null to clear the field (JSON payload)
          cleanMap[key] = null;
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
          final Map<String, dynamic> formDataMap = {};
          cleanMap.forEach((k, v) {
            if (k != 'avatarUrl') {
              // FormData values are converted to string. Use empty string for null.
              formDataMap[k] = v ?? '';
            }
          });
          formDataMap['avatar'] = await MultipartFile.fromFile(
            avatarUrl,
            filename: avatarUrl.split('/').last,
          );
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
      final responseData = _parseMapResponse(response.data);
      final rawData = responseData['data'];
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
      return MemberModel.fromJson(_parseMapData(_parseMapResponse(fallbackResponse.data)));
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi lưu thành viên',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
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
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  @override
  Future<List<BranchModel>> getBranches({int? familyId}) async {
    try {
      final queryParams = familyId != null ? {'familyId': familyId} : null;
      final response = await dio.get(
        AppConstants.branchesEndpoint,
        queryParameters: queryParams,
      );
      final responseData = _parseMapResponse(response.data);
      final data = _parseListData(responseData);
      return data
          .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }

  @override
  Future<BranchModel> getBranchById(int id) async {
    try {
      final response = await dio.get('${AppConstants.branchesEndpoint}/$id');
      final responseData = _parseMapResponse(response.data);
      return BranchModel.fromJson(_parseMapData(responseData));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundException(message: 'Không tìm thấy chi/nhánh');
      }
      throw ServerException(
        message: e.message ?? 'Lỗi kết nối máy chủ',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
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
      final responseData = _parseMapResponse(response.data);
      final rawData = responseData['data'];
      if (rawData is Map<String, dynamic>) {
        return BranchModel.fromJson(rawData);
      }
      // Fallback: re-fetch branch by id when update returns non-object
      final fallbackResponse = await dio.get(
        '${AppConstants.branchesEndpoint}/${branch.id}',
      );
      return BranchModel.fromJson(_parseMapData(_parseMapResponse(fallbackResponse.data)));
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Lỗi lưu chi/nhánh',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
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
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: null,
      );
    }
  }
}
