import 'package:equatable/equatable.dart';

class AuditLogEntity extends Equatable {
  final int id;
  final int? actorUserId;
  final String? actorName;
  final String? actorEmail;
  final String action;
  final String? targetType;
  final String? targetId;
  final Map<String, dynamic>? detail;
  final String? createdAt;

  const AuditLogEntity({
    required this.id,
    this.actorUserId,
    this.actorName,
    this.actorEmail,
    required this.action,
    this.targetType,
    this.targetId,
    this.detail,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        actorUserId,
        actorName,
        actorEmail,
        action,
        targetType,
        targetId,
        detail,
        createdAt,
      ];
}