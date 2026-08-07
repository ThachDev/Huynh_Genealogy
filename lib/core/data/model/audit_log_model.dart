import '../../domain/entity/audit_log_entity.dart';

class AuditLogModel extends AuditLogEntity {
  const AuditLogModel({
    required super.id,
    super.actorUserId,
    super.actorName,
    super.actorEmail,
    required super.action,
    super.targetType,
    super.targetId,
    super.detail,
    super.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: _parseInt(json['id']) ?? 0,
      actorUserId: _parseInt(json['actorUserId']),
      actorName: json['actorName'] as String?,
      actorEmail: json['actorEmail'] as String?,
      action: json['action'] as String? ?? '',
      targetType: json['targetType'] as String?,
      targetId: json['targetId']?.toString(),
      detail: json['detail'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['detail'] as Map)
          : null,
      createdAt: json['createdAt'] as String?,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}