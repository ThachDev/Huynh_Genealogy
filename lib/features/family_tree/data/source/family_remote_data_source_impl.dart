import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';
import 'package:app_family_tree/features/family_tree/data/source/family_data_source.dart';

class FamilyRemoteDataSourceImpl implements FamilyDataSource {
  final Dio dio;

  FamilyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MemberModel>> getMembers({int? branchId}) async {
    final response = await dio.get(
      '/members',
      queryParameters: branchId != null ? {'branchId': branchId} : null,
    );

    if (response.data['success'] == true) {
      final List list = response.data['data'];
      return list.map((json) => MemberModel.fromJson(json)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Lấy danh sách thành viên thất bại');
    }
  }

  @override
  Future<MemberModel> getMemberById(int id) async {
    final response = await dio.get('/members/$id');

    if (response.data['success'] == true) {
      return MemberModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Lấy thông tin thành viên thất bại');
    }
  }

  @override
  Future<MemberModel> saveMember(MemberModel member, {File? imageFile}) async {
    final Map<String, dynamic> memberJson = member.toJson();
    
    // Always use FormData for Multipart/form-data support (as per docs)
    final FormData formData = FormData.fromMap({
      ...memberJson,
      if (imageFile != null)
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
    });

    debugPrint('🚀 [API Request] POST /members (Multipart)');
    debugPrint('📦 Payload: $memberJson ${imageFile != null ? "(with image)" : "(no image)"}');

    try {
      final response = await dio.post(
        '/members',
        data: formData,
      );
      
      debugPrint('✅ [API Response] Code: ${response.statusCode}');
      
      if (response.data['success'] == true) {
        return MemberModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Lưu thành viên thất bại');
      }
    } on DioException catch (e) {
      debugPrint('❌ [API Error] Code: ${e.response?.statusCode}');
      debugPrint('📩 Error Response: ${e.response?.data}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteMember(int id) async {
    debugPrint('🚀 [API Request] DELETE /members/$id');
    final response = await dio.delete('/members/$id');

    if (response.data['success'] == true) {
      debugPrint('✅ [API Response] Member deleted');
      return true;
    } else {
      throw Exception(response.data['message'] ?? 'Xóa thành viên thất bại');
    }
  }

  @override
  Future<List<BranchModel>> getBranches() async {
    debugPrint('🚀 [API Request] GET /branches');
    final response = await dio.get('/branches');

    if (response.data['success'] == true) {
      final List list = response.data['data'];
      debugPrint('✅ [API Response] ${list.length} branches retrieved');
      return list.map((json) => BranchModel.fromJson(json)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Lấy danh sách chi/nhánh thất bại');
    }
  }

  @override
  Future<BranchModel> getBranchById(int id) async {
    debugPrint('🚀 [API Request] GET /branches/$id');
    final response = await dio.get('/branches/$id');

    if (response.data['success'] == true) {
      return BranchModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Lấy thông tin chi/nhánh thất bại');
    }
  }

  @override
  Future<BranchModel> saveBranch(BranchModel branch) async {
    final data = branch.toJson();
    final bool isUpdate = branch.id > 0;
    final String method = isUpdate ? 'PUT' : 'POST';
    final String url = isUpdate ? '/branches/${branch.id}' : '/branches';

    debugPrint('🚀 [API Request] $method $url');
    debugPrint('📦 Payload: $data');

    try {
      final response = await dio.request(
        url,
        data: data,
        options: Options(method: method),
      );
      debugPrint('✅ [API Response] Code: ${response.statusCode}');

      if (response.data['success'] == true) {
        return BranchModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Lưu chi/nhánh thất bại');
      }
    } on DioException catch (e) {
      debugPrint('❌ [API Error] Code: ${e.response?.statusCode}');
      debugPrint('📩 Error Response: ${e.response?.data}');
      rethrow;
    }
  }

  @override
  Future<bool> deleteBranch(int id) async {
    debugPrint('🚀 [API Request] DELETE /branches/$id');
    final response = await dio.delete('/branches/$id');

    if (response.data['success'] == true) {
      return true;
    } else {
      throw Exception(response.data['message'] ?? 'Xóa chi/nhánh thất bại');
    }
  }
}
