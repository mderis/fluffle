import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/domain/usecases/use_case.dart';
import 'package:app_template/features/auth/domain/entities/auth_tokens.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class Login extends UseCase<AuthTokens, LoginParams> {
  final AuthRepository _repository;

  Login(this._repository);

  @override
  Future<Either<Failure, AuthTokens>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
