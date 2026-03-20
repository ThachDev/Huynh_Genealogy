import 'package:dio/dio.dart';
import 'package:app_family_tree/core/logger/log.dart';
import 'package:app_family_tree/features/branch/data/models/branch_model.dart';

class BranchApiService with LogMixin {
  BranchApiService(this._dio);

  final Dio _dio;

  Future<List<BranchModel>> getBranches() async {
    logD('GET /branches');
    final response = await _dio.get('/branches');
    if (response.data['success'] == true) {
      final List list = response.data['data'];
      return list.map((json) => BranchModel.fromJson(json)).toList();
    }
    throw Exception(response.data['message'] ?? 'Lấy danh sách chi/nhánh thất bại');
  }

  Future<BranchModel> getBranchById(int id) async {
    logD('GET /branches/$id');
    final response = await _dio.get('/branches/$id');
    if (response.data['success'] == true) {
      return BranchModel.fromJson(response.data['data']);
    }
    throw Exception(response.data['message'] ?? 'Lấy thông tin chi/nhánh thất bại');
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
