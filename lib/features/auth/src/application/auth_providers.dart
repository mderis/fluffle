import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/api/dio_provider.dart';
import 'package:app_template/core/config/app_config_provider.dart';
import 'package:app_template/features/auth/src/data/auth_api.dart';
import 'package:app_template/features/auth/src/data/auth_repository_impl.dart';
import 'package:app_template/features/auth/src/domain/auth_repository.dart';

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
