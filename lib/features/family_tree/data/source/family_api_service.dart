import 'dart:io';
import 'package:dio/dio.dart';
import 'package:app_family_tree/core/logger/log.dart';
import 'package:app_family_tree/features/family_tree/data/model/branch_model.dart';
import 'package:app_family_tree/features/family_tree/data/model/member_model.dart';

class FamilyApiService with LogMixin {
  FamilyApiService(this._dio);

  final Dio _dio;

  // ─── Members ──────────────────────────────────────────────────────────────

  Future<List<MemberModel>> getMembers({int? branchId}) async {
    final response = await _dio.get(
      '/members',
      queryParameters: branchId != null ? {'branchId': branchId} : null,
    );
    if (response.data['success'] == true) {
      final List list = response.data['data'];
      return list.map((json) => MemberModel.fromJson(json)).toList();
    }
    throw Exception(
      response.data['message'] ?? 'Lấy danh sách thành viên thất bại',
    );
  }

  Future<MemberModel> getMemberById(int id) async {
    final response = await _dio.get('/members/$id');
    if (response.data['success'] == true) {
      return MemberModel.fromJson(response.data['data']);
    }
    throw Exception(
      response.data['message'] ?? 'Lấy thông tin thành viên thất bại',
    );
  }

  Future<MemberModel> saveMember(MemberModel member, {File? imageFile}) async {
    final Map<String, dynamic> memberJson = member.toJson()
      ..removeWhere((_, v) => v == null);
    if (memberJson['id'] == 0) memberJson.remove('id');

    final bool isUpdate = (member.id ?? 0) > 0;
    final String url = isUpdate ? '/members/${member.id}' : '/members';

    logD('${isUpdate ? "PUT" : "POST"} $url');

    // Dùng FormData để support upload ảnh
    final FormData formData = FormData.fromMap({
      ...memberJson,
      if (imageFile != null)
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
    });

    final response = isUpdate
        ? await _dio.put(url, data: formData)
        : await _dio.post(url, data: formData);

    if (response.data['success'] == true) {
      return MemberModel.fromJson(response.data['data']);
    }
    throw Exception(response.data['message'] ?? 'Lưu thành viên thất bại');
  }

  Future<bool> deleteMember(int id) async {
    logD('DELETE /members/$id');
    final response = await _dio.delete('/members/$id');
    if (response.data['success'] == true) return true;
    throw Exception(response.data['message'] ?? 'Xóa thành viên thất bại');
  }

  // ─── Branches ─────────────────────────────────────────────────────────────

  Future<List<BranchModel>> getBranches() async {
    logD('GET /branches');
    final response = await _dio.get('/branches');
    if (response.data['success'] == true) {
      final List list = response.data['data'];
      return list.map((json) => BranchModel.fromJson(json)).toList();
    }
    throw Exception(
      response.data['message'] ?? 'Lấy danh sách chi/nhánh thất bại',
    );
  }

  Future<BranchModel> getBranchById(int id) async {
    final response = await _dio.get('/branches/$id');
    if (response.data['success'] == true) {
      return BranchModel.fromJson(response.data['data']);
    }
    throw Exception(
      response.data['message'] ?? 'Lấy thông tin chi/nhánh thất bại',
    );
  }

  Future<BranchModel> saveBranch(BranchModel branch) async {
    final data = branch.toJson()..removeWhere((_, v) => v == null);
    if (data['id'] == 0) data.remove('id');

    final bool isUpdate = (branch.id ?? 0) > 0;
    final String url = isUpdate ? '/branches/${branch.id}' : '/branches';

    logD('${isUpdate ? "PUT" : "POST"} $url - Payload: $data');

    final response = isUpdate
        ? await _dio.put(url, data: data)
        : await _dio.post(url, data: data);

    if (response.data['success'] == true) {
      return BranchModel.fromJson(response.data['data']);
    }
    throw Exception(response.data['message'] ?? 'Lưu chi/nhánh thất bại');
  }

  Future<bool> deleteBranch(int id) async {
    logD('DELETE /branches/$id');
    final response = await _dio.delete('/branches/$id');
    if (response.data['success'] == true) return true;
    throw Exception(response.data['message'] ?? 'Xóa chi/nhánh thất bại');
  }
}
