import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/event_interaction.dart';

/// Data source cho các tương tác với sự kiện (reaction, bình luận, đọc, ẩn).
///
/// Không nuốt lỗi: mọi lỗi đều được ném dưới dạng [AppException] có kiểu cụ thể
/// ([ServerException], [NetworkException], [AppTimeoutException]) để repository
/// layer map qua `ErrorHandler` như toàn bộ data source khác.
class EventApiService {

  EventApiService({required this.dio});
  final Dio dio;

  /// Toggle tim/thích bài viết sự kiện.
  Future<Map<String, dynamic>> reactToEvent(int eventId) async {
    final response = await _request(
      () => dio.post('${AppConstants.eventsEndpoint}/$eventId/react'),
    );
    final data = response.data;
    if (data != null && data['success'] == true) {
      return data['data'] as Map<String, dynamic>;
    }
    throw ServerException(message: _messageOf(data));
  }

  /// Lấy danh sách bình luận của sự kiện.
  Future<List<EventInteractionModel>> getComments(int eventId) async {
    final response = await _request(
      () => dio.get('${AppConstants.eventsEndpoint}/$eventId/comments'),
    );
    final data = response.data;
    if (data != null && data['success'] == true) {
      final List list = data['data'] ?? [];
      return list
          .map((e) => EventInteractionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw ServerException(message: _messageOf(data));
  }

  /// Gửi bình luận mới cho sự kiện.
  Future<EventInteractionModel> createComment(int eventId, String content) async {
    final response = await _request(
      () => dio.post(
        '${AppConstants.eventsEndpoint}/$eventId/comments',
        data: {'content': content},
      ),
    );
    final data = response.data;
    if (data != null && data['success'] == true) {
      return EventInteractionModel.fromJson(
        data['data'] as Map<String, dynamic>,
      );
    }
    throw ServerException(message: _messageOf(data));
  }

  /// Đánh dấu đã đọc một sự kiện/thông báo.
  Future<bool> markEventAsRead(int eventId) async {
    final response = await _request(
      () => dio.post('${AppConstants.eventsEndpoint}/$eventId/read'),
    );
    return _isSuccess(response.data);
  }

  /// Đánh dấu đã đọc tất cả thông báo của gia đình.
  Future<bool> markAllEventsAsRead() async {
    final response = await _request(
      () => dio.post('${AppConstants.eventsEndpoint}/read-all'),
    );
    return _isSuccess(response.data);
  }

  /// Xoá/Ẩn một thông báo khỏi hòm thư cá nhân.
  Future<bool> dismissEvent(int eventId) async {
    final response = await _request(
      () => dio.post('${AppConstants.eventsEndpoint}/$eventId/dismiss'),
    );
    return _isSuccess(response.data);
  }

  /// Xoá/Ẩn tất cả thông báo khỏi hòm thư cá nhân.
  Future<bool> dismissAllEvents() async {
    final response = await _request(
      () => dio.post('${AppConstants.eventsEndpoint}/dismiss-all'),
    );
    return _isSuccess(response.data);
  }

  Future<Response<dynamic>> _request(Future<Response<dynamic>> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  AppException _mapDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data is Map
        ? (e.response?.data as Map)['message'] as String?
        : null;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppTimeoutException(message: message ?? e.message);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(message: message ?? e.message);
      default:
        return ServerException(
          message: message ?? e.message,
          statusCode: statusCode,
        );
    }
  }

  bool _isSuccess(dynamic data) {
    if (data is Map && data['success'] == true) {
      return true;
    }
    throw ServerException(message: _messageOf(data));
  }

  String? _messageOf(dynamic data) {
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}