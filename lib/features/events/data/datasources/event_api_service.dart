import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';

class EventInteractionModel {

  EventInteractionModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory EventInteractionModel.fromJson(Map<String, dynamic> json) {
    return EventInteractionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      eventId: (json['eventId'] as num?)?.toInt() ?? (json['event_id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? (json['user_id'] as num?)?.toInt() ?? 0,
      authorName: json['authorName'] as String? ?? json['author_name'] as String? ?? json['userName'] as String? ?? 'Thành viên',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String? ?? '',
    );
  }
  final int id;
  final int eventId;
  final int userId;
  final String authorName;
  final String content;
  final String createdAt;
}

class EventApiService {

  EventApiService({required this.dio});
  final Dio dio;

  /// Toggle tim/thích bài viết sự kiện
  Future<Map<String, dynamic>?> reactToEvent(int eventId) async {
    try {
      final response = await dio.post('${AppConstants.eventsEndpoint}/$eventId/react');
      final data = response.data;
      if (data != null && data['success'] == true) {
        return data['data'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Lấy danh sách bình luận của sự kiện
  Future<List<EventInteractionModel>> getComments(int eventId) async {
    try {
      final response = await dio.get('${AppConstants.eventsEndpoint}/$eventId/comments');
      final data = response.data;
      if (data != null && data['success'] == true) {
        final List list = data['data'] ?? [];
        return list.map((e) => EventInteractionModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Gửi bình luận mới cho sự kiện
  Future<EventInteractionModel?> createComment(int eventId, String content) async {
    try {
      final response = await dio.post(
        '${AppConstants.eventsEndpoint}/$eventId/comments',
        data: {'content': content},
      );
      final data = response.data;
      if (data != null && data['success'] == true) {
        return EventInteractionModel.fromJson(data['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Đánh dấu đã đọc một sự kiện/thông báo
  Future<bool> markEventAsRead(int eventId) async {
    try {
      final response = await dio.post('${AppConstants.eventsEndpoint}/$eventId/read');
      final data = response.data;
      return data != null && data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Đánh dấu đã đọc tất cả thông báo của gia đình
  Future<bool> markAllEventsAsRead() async {
    try {
      final response = await dio.post('${AppConstants.eventsEndpoint}/read-all');
      final data = response.data;
      return data != null && data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Xoá/Ẩn một thông báo khỏi hòm thư cá nhân
  Future<bool> dismissEvent(int eventId) async {
    try {
      final response = await dio.post('${AppConstants.eventsEndpoint}/$eventId/dismiss');
      final data = response.data;
      return data != null && data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Xoá/Ẩn tất cả thông báo khỏi hòm thư cá nhân
  Future<bool> dismissAllEvents() async {
    try {
      final response = await dio.post('${AppConstants.eventsEndpoint}/dismiss-all');
      final data = response.data;
      return data != null && data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}


