import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class ForgotPassword implements UseCase<void, ForgotPasswordParams> {

  ForgotPassword(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams extends Equatable {

  const ForgotPasswordParams({required this.email});
  final String email;

  @override
  List<Object?> get props => [email];
}
