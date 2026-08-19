class WishMessage {

  WishMessage({
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
  });

  factory WishMessage.fromJson(Map<String, dynamic> json) {
    final rawReacted = json['isReacted'] ?? json['is_reacted'] ?? json['reacted'];
    final bool reacted = rawReacted is bool
        ? rawReacted
        : (rawReacted is num ? rawReacted == 1 : rawReacted.toString() == 'true' || rawReacted.toString() == '1');

    return WishMessage(
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
}
