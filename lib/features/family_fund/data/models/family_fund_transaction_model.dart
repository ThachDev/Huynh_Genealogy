import 'dart:convert';

class FamilyFundTransactionModel {
  final String id;
  final double amount;
  final String type; // 'IN' (Thu / Đóng góp), 'OUT' (Chi)
  final String category; // 'Đóng góp', 'Hiếu hỷ', 'Xây dựng', 'Khuyến học', 'Họp mặt', vv.
  final String description;
  final String senderName;
  final String? senderId;
  final DateTime createdAt;
  final String status; // 'PENDING', 'COMPLETED', 'REJECTED'
  final String? evidenceUrl;

  FamilyFundTransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    required this.senderName,
    this.senderId,
    required this.createdAt,
    required this.status,
    this.evidenceUrl,
  });

  FamilyFundTransactionModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? category,
    String? description,
    String? senderName,
    String? senderId,
    DateTime? createdAt,
    String? status,
    String? evidenceUrl,
  }) {
    return FamilyFundTransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      description: description ?? this.description,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      evidenceUrl: evidenceUrl ?? this.evidenceUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'senderName': senderName,
      'senderId': senderId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
      'evidenceUrl': evidenceUrl,
    };
  }

  factory FamilyFundTransactionModel.fromMap(Map<String, dynamic> map) {
    return FamilyFundTransactionModel(
      id: map['id'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] ?? 'IN',
      category: map['category'] ?? 'Khác',
      description: map['description'] ?? '',
      senderName: map['senderName'] ?? '',
      senderId: map['senderId'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      status: map['status'] ?? 'COMPLETED',
      evidenceUrl: map['evidenceUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyFundTransactionModel.fromJson(String source) => 
      FamilyFundTransactionModel.fromMap(json.decode(source));
}
