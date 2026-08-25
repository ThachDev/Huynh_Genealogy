import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/onboarding_repository.dart';

/// ============================================================================
/// USE CASE — LINK MEMBER TO USER (DOMAIN LAYER)
/// ============================================================================
/// Đảm nhận nghiệp vụ gán/liên kết tài khoản người dùng (`userId`) với một nút thành viên
/// (`memberId`) đã tồn tại trên sơ đồ cây gia phả.
/// ============================================================================
class LinkMemberToUser implements UseCase<bool, LinkMemberToUserParams> {

  LinkMemberToUser(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, bool>> call(LinkMemberToUserParams params) {
    return repository.linkMemberToUser(
      userId: params.userId,
      memberId: params.memberId,
    );
  }
}

class LinkMemberToUserParams extends Equatable {

  const LinkMemberToUserParams({
    required this.userId,
    required this.memberId,
  });
  final int userId;
  final int memberId;

  @override
  List<Object?> get props => [userId, memberId];
}
