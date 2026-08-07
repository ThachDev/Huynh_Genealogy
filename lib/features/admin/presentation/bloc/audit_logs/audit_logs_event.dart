part of 'audit_logs_bloc.dart';

abstract class AuditLogsEvent extends Equatable {
  const AuditLogsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAuditLogsEvent extends AuditLogsEvent {
  final int? familyId;
  final int? limit;

  const LoadAuditLogsEvent({this.familyId, this.limit});

  @override
  List<Object?> get props => [familyId, limit];
}