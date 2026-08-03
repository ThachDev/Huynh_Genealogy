class WishMessage {
  final int id;
  final int familyId;
  final int memberId;
  final int senderId;
  final String content;
  final String eventType;
  final DateTime createdAt;
  final String? senderName;
  final String? senderAvatar;

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
  });

  factory WishMessage.fromJson(Map<String, dynamic> json) {
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
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familyId': familyId,
      'memberId': memberId,
      'senderId': senderId,
      'content': content,
      'eventType': eventType,
    };
  }
}
