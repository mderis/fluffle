import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/entities/user.dart';
import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/domain/usecases/use_case.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser extends NoParamsUseCase<User> {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  @override
  Future<Either<Failure, User>> call() {
    return _repository.getCurrentUser();
  }
}
