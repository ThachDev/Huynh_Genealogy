import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/member_account_link_repository.dart';

class UnlinkMemberAccount
    implements UseCase<bool, UnlinkMemberAccountParams> {
  final MemberAccountLinkRepository repository;

  UnlinkMemberAccount(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnlinkMemberAccountParams params) {
    return repository.unlinkMember(
      familyId: params.familyId,
      memberId: params.memberId,
    );
  }
}

class UnlinkMemberAccountParams extends Equatable {
  final int familyId;
  final int memberId;

  const UnlinkMemberAccountParams({
    required this.familyId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [familyId, memberId];
}