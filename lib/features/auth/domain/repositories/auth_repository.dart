import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/entities/user.dart';
import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/features/auth/domain/entities/auth_tokens.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthTokens>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, User>> updateUser({
    required String id,
    String? name,
    String? username,
  });
}
