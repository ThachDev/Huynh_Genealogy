import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/member_account_link_entity.dart';

abstract class MemberAccountLinkRepository {
  Future<Either<Failure, List<MemberAccountLinkEntity>>> getAccountLinks(
    int familyId,
  );

  /// Liên kết tài khoản bằng email. Nếu email chưa có tài khoản tương ứng thì
  /// tạo lời mời và gửi email (trả về `invited == true`). Nếu đã có tài khoản
  /// thì liên kết ngay (trả về `linked == true`).
  Future<Either<Failure, LinkAccountResult>> linkMemberAccount({
    required int familyId,
    required int memberId,
    required String email,
  });

  /// Gỡ liên kết tài khoản / lời mời khỏi một nút.
  Future<Either<Failure, bool>> unlinkMember({
    required int familyId,
    required int memberId,
  });
}

class LinkAccountResult {
  final bool linked;
  final bool invited;
  final String email;

  const LinkAccountResult({
    required this.linked,
    required this.invited,
    required this.email,
  });
}