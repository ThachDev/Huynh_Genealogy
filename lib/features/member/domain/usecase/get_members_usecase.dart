import 'package:dartz/dartz.dart';
import 'package:app_family_tree/core/usecase/usecase.dart';
import 'package:app_family_tree/core/error/failures.dart';
import 'package:app_family_tree/features/member/domain/entities/member.dart';
import 'package:app_family_tree/features/member/domain/repositories/member_repository.dart';

class GetMembersUseCase extends UseCase<List<MemberEntity>, GetMembersParams> {
  final MemberRepository repository;

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
