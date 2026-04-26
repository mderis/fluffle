import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/entities/user.dart';
import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/domain/usecases/use_case.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserParams {
  final String id;
  final String? name;
  final String? username;

  const UpdateUserParams({required this.id, this.name, this.username});
}

class UpdateUser extends UseCase<User, UpdateUserParams> {
  final AuthRepository _repository;

  UpdateUser(this._repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) {
    return _repository.updateUser(
      id: params.id,
      name: params.name,
      username: params.username,
    );
  }
}
