import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/domain/usecases/use_case.dart';
import 'package:app_template/features/auth/domain/entities/auth_tokens.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });
}

class Register extends UseCase<AuthTokens, RegisterParams> {
  final AuthRepository _repository;

  Register(this._repository);

  @override
  Future<Either<Failure, AuthTokens>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}
