import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giatocviet/features/family_tree/domain/entities/audit_log_entity.dart';
import '../../../domain/usecase/get_audit_logs.dart';

part 'audit_logs_event.dart';
part 'audit_logs_state.dart';

class AuditLogsBloc extends Bloc<AuditLogsEvent, AuditLogsState> {

  AuditLogsBloc({required this.getAuditLogs}) : super(const AuditLogsInitial()) {
    on<LoadAuditLogsEvent>(_onLoad);
  }
  final GetAuditLogs getAuditLogs;

  Future<void> _onLoad(
    LoadAuditLogsEvent event,
    Emitter<AuditLogsState> emit,
  ) async {
    emit(const AuditLogsLoading());
    final result = await getAuditLogs(GetAuditLogsParams(
      familyId: event.familyId,
      limit: event.limit,
    ));
    result.fold(
      (failure) => emit(AuditLogsFailure(message: failure.message)),
      (logs) => emit(AuditLogsLoaded(logs: logs)),
    );
  }
}