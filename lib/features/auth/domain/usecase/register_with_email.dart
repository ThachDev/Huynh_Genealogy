import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:giatocviet/core/domain/entity/user_entity.dart';
import '../repository/auth_repository.dart';

class RegisterWithEmail implements UseCase<UserEntity, RegisterParams> {

  RegisterWithEmail(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) {
    return repository.registerWithEmail(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      role: params.role,
    );
  }
}

class RegisterParams extends Equatable {

  const RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });
  final String email;
  final String password;
  final String fullName;
  final String role;

  @override
  List<Object?> get props => [email, password, fullName, role];
}
