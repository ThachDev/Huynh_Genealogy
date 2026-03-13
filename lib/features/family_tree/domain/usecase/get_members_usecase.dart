import 'package:dartz/dartz.dart';
import 'package:app_family_tree/base/usecase.dart';
import 'package:app_family_tree/exception_handler/failures.dart';
import 'package:app_family_tree/features/family_tree/domain/entities/member.dart';
import 'package:app_family_tree/features/family_tree/domain/repositories/family_repository.dart';

class GetMembersUseCase extends UseCase<List<MemberEntity>, GetMembersParams> {
  final FamilyRepository repository;

  GetMembersUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MemberEntity>>> call(GetMembersParams params) {
    return repository.getMembers(branchId: params.branchId);
  }
}

class GetMembersParams {
  final int? branchId;

  GetMembersParams({this.branchId});
}
