import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/member_account_link_repository.dart';

class UnlinkMemberAccount
    implements UseCase<bool, UnlinkMemberAccountParams> {

  UnlinkMemberAccount(this.repository);
  final MemberAccountLinkRepository repository;

  @override
  Future<Either<Failure, bool>> call(UnlinkMemberAccountParams params) {
    return repository.unlinkMember(
      familyId: params.familyId,
      memberId: params.memberId,
    );
  }
}

class UnlinkMemberAccountParams extends Equatable {

  const UnlinkMemberAccountParams({
    required this.familyId,
    required this.memberId,
  });
  final int familyId;
  final int memberId;

  @override
  List<Object?> get props => [familyId, memberId];
}