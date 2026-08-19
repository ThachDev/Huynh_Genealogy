import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class VerifyOtp implements UseCase<void, VerifyOtpParams> {

  VerifyOtp(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) {
    return repository.verifyOtp(email: params.email, otp: params.otp);
  }
}

class VerifyOtpParams extends Equatable {

  const VerifyOtpParams({required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  List<Object?> get props => [email, otp];
}
