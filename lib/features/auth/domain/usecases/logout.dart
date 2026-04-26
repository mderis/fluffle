import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/domain/usecases/use_case.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class Logout extends NoParamsUseCase<Unit> {
  final AuthRepository _repository;

  Logout(this._repository);

  @override
  Future<Either<Failure, Unit>> call() {
    return _repository.logout();
  }
}
