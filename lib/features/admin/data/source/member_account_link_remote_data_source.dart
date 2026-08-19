import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/member_account_link_entity.dart';
import '../../domain/repository/member_account_link_repository.dart';
import '../models/member_account_link_model.dart';

abstract class MemberAccountLinkRemoteDataSource {
  Future<List<MemberAccountLinkEntity>> getAccountLinks(int familyId);

  Future<LinkAccountResult> linkMember({
    required int memberId,
    required String email,
  });

  Future<bool> unlinkMember({required int memberId});
}

class MemberAccountLinkRemoteDataSourceImpl
    implements MemberAccountLinkRemoteDataSource {

  MemberAccountLinkRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<MemberAccountLinkEntity>> getAccountLinks(int familyId) async {
    try {
      final response = await dio.get(
        '${AppConstants.familiesEndpoint}/accounts',
        queryParameters: {'familyId': familyId},
      );
      final list = response.data['data'] as List<dynamic>? ?? [];
      return list
          .map((json) =>
              MemberAccountLinkModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: _getErrorMessage(e,
            AppLanguage.current?.errLoadMemberList ?? 'Lỗi tải danh sách thành viên'),
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<LinkAccountResult> linkMember({
    required int memberId,
    required String email,
  }) async {
    try {
      final response = await dio.post(
        '${AppConstants.familiesEndpoint}/members/$memberId/link-account',
        data: {'email': email},
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final linked = data['linked'] as bool? ?? false;
      final invited = data['invited'] as bool? ?? false;
      return LinkAccountResult(
        linked: linked,
        invited: invited,
        email: data['email'] as String? ?? email,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi liên kết tài khoản',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<bool> unlinkMember({required int memberId}) async {
    try {
      final response = await dio.delete(
        '${AppConstants.familiesEndpoint}/members/$memberId/link-account',
      );
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Lỗi gỡ liên kết tài khoản',
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