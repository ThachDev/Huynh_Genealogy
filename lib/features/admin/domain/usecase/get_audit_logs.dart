import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/audit_log_entity.dart';
import '../../../family_tree/domain/repository/family_tree_repository.dart';

class GetAuditLogs implements UseCase<List<AuditLogEntity>, GetAuditLogsParams> {
  final FamilyTreeRepository repository;

  GetAuditLogs(this.repository);

  @override
  Future<Either<Failure, List<AuditLogEntity>>> call(GetAuditLogsParams params) {
    return repository.getAuditLogs(familyId: params.familyId, limit: params.limit);
  }
}

class GetAuditLogsParams extends Equatable {
  final int? familyId;
  final int? limit;

  const GetAuditLogsParams({this.familyId, this.limit});

  @override
  List<Object?> get props => [familyId, limit];
}
