part of 'audit_logs_bloc.dart';

abstract class AuditLogsState extends Equatable {
  const AuditLogsState();

  @override
  List<Object?> get props => [];
}

class AuditLogsInitial extends AuditLogsState {
  const AuditLogsInitial();
}

class AuditLogsLoading extends AuditLogsState {
  const AuditLogsLoading();
}

class AuditLogsLoaded extends AuditLogsState {
  final List<AuditLogEntity> logs;

  const AuditLogsLoaded({required this.logs});

  @override
  List<Object?> get props => [logs];
}

class AuditLogsFailure extends AuditLogsState {
  final String message;

  const AuditLogsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}