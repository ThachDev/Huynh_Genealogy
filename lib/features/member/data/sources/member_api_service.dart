import 'dart:io';
import 'package:dio/dio.dart';
import 'package:app_family_tree/core/logger/log.dart';
import 'package:app_family_tree/features/member/data/models/member_model.dart';

class MemberApiService with LogMixin {
  MemberApiService(this._dio);

  final Dio _dio;

  Future<List<MemberModel>> getMembers({int? branchId}) async {
    logD('GET /members${branchId != null ? "?branchId=$branchId" : ""}');
    final response = await _dio.get(
      '/members',
      queryParameters: branchId != null ? {'branchId': branchId} : null,
    );
    if (response.data['success'] == true) {
      final List list = response.data['data'];
      return list.map((json) => MemberModel.fromJson(json)).toList();
    }
    throw Exception(response.data['message'] ?? 'Lấy danh sách thành viên thất bại');
  }

  Future<MemberModel> getMemberById(int id) async {
    logD('GET /members/$id');
    final response = await _dio.get('/members/$id');
    if (response.data['success'] == true) {
      return MemberModel.fromJson(response.data['data']);
    }
    throw Exception(response.data['message'] ?? 'Lấy thông tin thành viên thất bại');
  }

  Future<MemberModel> saveMember(MemberModel member, {File? imageFile}) async {
    final Map<String, dynamic> memberJson = member.toJson()
      ..removeWhere((_, v) => v == null);
    if (memberJson['id'] == 0) memberJson.remove('id');

    final bool isUpdate = (member.id ?? 0) > 0;
    final String url = isUpdate ? '/members/${member.id}' : '/members';

    logD('${isUpdate ? "PUT" : "POST"} $url');

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
}
