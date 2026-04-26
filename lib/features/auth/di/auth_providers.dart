import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/api/dio_provider.dart';
import 'package:app_template/core/config/app_config_provider.dart';
import 'package:app_template/features/auth/data/datasources/auth_api.dart';
import 'package:app_template/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app_template/features/auth/domain/repositories/auth_repository.dart';
import 'package:app_template/features/auth/domain/usecases/forgot_password.dart';
import 'package:app_template/features/auth/domain/usecases/get_current_user.dart';
import 'package:app_template/features/auth/domain/usecases/login.dart';
import 'package:app_template/features/auth/domain/usecases/logout.dart';
import 'package:app_template/features/auth/domain/usecases/register.dart';
import 'package:app_template/features/auth/domain/usecases/update_user.dart';

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(ref.watch(dioProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    api: ref.watch(authApiProvider),
    storage: ref.watch(secureStorageProvider),
    config: ref.watch(appConfigProvider),
  ),
);

final loginUseCaseProvider = Provider<Login>(
  (ref) => Login(ref.watch(authRepositoryProvider)),
);

final registerUseCaseProvider = Provider<Register>(
  (ref) => Register(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<Logout>(
  (ref) => Logout(ref.watch(authRepositoryProvider)),
);

final getCurrentUserUseCaseProvider = Provider<GetCurrentUser>(
  (ref) => GetCurrentUser(ref.watch(authRepositoryProvider)),
);

final forgotPasswordUseCaseProvider = Provider<ForgotPassword>(
  (ref) => ForgotPassword(ref.watch(authRepositoryProvider)),
);

final updateUserUseCaseProvider = Provider<UpdateUser>(
  (ref) => UpdateUser(ref.watch(authRepositoryProvider)),
);
