import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/domain/usecases/use_case.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword extends UseCase<Unit, String> {
  final AuthRepository _repository;

  ForgotPassword(this._repository);

  @override
  Future<Either<Failure, Unit>> call(String email) {
    return _repository.forgotPassword(email: email);
  }
}
