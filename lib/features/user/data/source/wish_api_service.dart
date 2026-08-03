import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../presentation/models/wish_message.dart';

class WishApiService {
  final Dio dio;

  WishApiService({required this.dio});

  Future<List<WishMessage>> getWishesByMember(int memberId) async {
    try {
      final response = await dio.get('${AppConstants.baseUrl}/wishes/member/$memberId');
      final data = response.data;
      if (data != null && data['success'] == true) {
        final List list = data['data'] ?? [];
        return list.map((e) => WishMessage.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<WishMessage?> createWish(WishMessage wish) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/wishes',
        data: wish.toJson(),
      );
      final data = response.data;
      if (data != null && data['success'] == true) {
        return WishMessage.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
