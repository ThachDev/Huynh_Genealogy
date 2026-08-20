/// Mô hình biểu diễn một tương tác (bình luận) với sự kiện.
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
      eventId: (json['eventId'] as num?)?.toInt() ??
          (json['event_id'] as num?)?.toInt() ??
          0,
      userId: (json['userId'] as num?)?.toInt() ??
          (json['user_id'] as num?)?.toInt() ??
          0,
      authorName: json['authorName'] as String? ??
          json['author_name'] as String? ??
          json['userName'] as String? ??
          'Thành viên',
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