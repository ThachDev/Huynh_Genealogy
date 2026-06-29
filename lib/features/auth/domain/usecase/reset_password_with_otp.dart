import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class ResetPasswordWithOtp
    implements UseCase<void, ResetPasswordWithOtpParams> {
  final AuthRepository repository;

  ResetPasswordWithOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordWithOtpParams params) {
    return repository.resetPasswordWithOtp(
      email: params.email,
      otp: params.otp,
      newPassword: params.newPassword,
    );
  }
}

class ResetPasswordWithOtpParams extends Equatable {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordWithOtpParams({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}
