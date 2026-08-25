/// Entity đại diện cho một lời chúc/ghi nhớ trên Tường Chúc.
class WishEntity {
  const WishEntity({
    required this.id,
    required this.familyId,
    required this.memberId,
    required this.senderId,
    required this.content,
    required this.eventType,
    required this.createdAt,
    this.senderName,
    this.senderAvatar,
    this.reactionCount = 0,
    this.isReacted = false,
    this.isRead = false,
  });

  factory WishEntity.fromJson(Map<String, dynamic> json) {
    final rawReacted = json['isReacted'] ?? json['is_reacted'] ?? json['reacted'];
    final bool reacted = rawReacted is bool
        ? rawReacted
        : (rawReacted is num
            ? rawReacted == 1
            : rawReacted.toString() == 'true' || rawReacted.toString() == '1');

    final rawIsRead = json['isRead'] ?? json['is_read'];
    final bool isRead = rawIsRead is bool
        ? rawIsRead
        : (rawIsRead is num
            ? rawIsRead == 1
            : rawIsRead.toString() == 'true' || rawIsRead.toString() == '1');

    return WishEntity(
      id: json['id'] ?? 0,
      familyId: json['familyId'] ?? 0,
      memberId: json['memberId'] ?? 0,
      senderId: json['senderId'] ?? 0,
      content: json['content'] ?? '',
      eventType: json['eventType'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      senderName: json['senderName'] ?? json['sender_name'],
      senderAvatar: json['senderAvatar'] ?? json['sender_avatar'],
      reactionCount: (json['reactionCount'] as num?)?.toInt() ??
          (json['reaction_count'] as num?)?.toInt() ??
          0,
      isReacted: reacted,
      isRead: isRead,
    );
  }

  final int id;
  final int familyId;
  final int memberId;
  final int senderId;
  final String content;
  final String eventType;
  final DateTime createdAt;
  final String? senderName;
  final String? senderAvatar;
  final int reactionCount;
  final bool isReacted;
  final bool isRead;

  Map<String, dynamic> toJson() {
    return {
      'familyId': familyId,
      'memberId': memberId,
      'senderId': senderId,
      'content': content,
      'eventType': eventType,
      'reactionCount': reactionCount,
      'isReacted': isReacted,
    };
  }

  WishEntity copyWith({
    int? id,
    int? familyId,
    int? memberId,
    int? senderId,
    String? content,
    String? eventType,
    DateTime? createdAt,
    String? senderName,
    String? senderAvatar,
    int? reactionCount,
    bool? isReacted,
    bool? isRead,
  }) {
    return WishEntity(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      memberId: memberId ?? this.memberId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      eventType: eventType ?? this.eventType,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      reactionCount: reactionCount ?? this.reactionCount,
      isReacted: isReacted ?? this.isReacted,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          familyId == other.familyId &&
          memberId == other.memberId &&
          senderId == other.senderId &&
          content == other.content &&
          eventType == other.eventType &&
          createdAt == other.createdAt &&
          senderName == other.senderName &&
          senderAvatar == other.senderAvatar &&
          reactionCount == other.reactionCount &&
          isReacted == other.isReacted &&
          isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      familyId.hashCode ^
      memberId.hashCode ^
      senderId.hashCode ^
      content.hashCode ^
      eventType.hashCode ^
      createdAt.hashCode ^
      senderName.hashCode ^
      senderAvatar.hashCode ^
      reactionCount.hashCode ^
      isReacted.hashCode ^
      isRead.hashCode;
}