import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/onboarding_repository.dart';

/// ============================================================================
/// USE CASE — VERIFY INVITE CODE (DOMAIN LAYER)
/// ============================================================================
/// Đảm nhận nghiệp vụ kiểm tra và xác thực mã mời gia nhập dòng họ.
///
/// Đầu vào: chuỗi mã mời (`String code`).
/// Đầu ra: `Map<String, dynamic>` chứa thông tin dòng họ (`FamilyEntity`) và danh sách
/// các thành viên hiện có trên cây gia phả (`List<MemberEntity>`) để người dùng lựa chọn liên kết.
/// ============================================================================
class VerifyInviteCode implements UseCase<Map<String, dynamic>, String> {

  VerifyInviteCode(this.repository);
  final OnboardingRepository repository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String code) {
    return repository.verifyInviteCode(code: code);
  }
}
