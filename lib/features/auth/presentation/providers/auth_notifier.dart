import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/analytics/analytics_provider.dart';
import 'package:app_template/core/domain/entities/user.dart';
import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/monitoring/error_reporter_provider.dart';
import 'package:app_template/features/auth/di/auth_providers.dart';
import 'package:app_template/features/auth/domain/usecases/login.dart';
import 'package:app_template/features/auth/domain/usecases/register.dart';
import 'package:app_template/features/auth/domain/usecases/update_user.dart';

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final result = await ref.read(getCurrentUserUseCaseProvider).call();
    return result.fold(
      (failure) => null,
      (user) {
        _identifyUser(user);
        return user;
      },
    );
  }

  Future<Failure?> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(loginUseCaseProvider).call(
          LoginParams(email: email, password: password),
        );

    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure;
      },
      (tokens) async {
        final userResult = await ref.read(getCurrentUserUseCaseProvider).call();
        return userResult.fold(
          (failure) {
            state = const AsyncData(null);
            return failure;
          },
          (user) {
            _identifyUser(user);
            state = AsyncData(user);
            return null;
          },
        );
      },
    );
  }

  Future<Failure?> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncLoading();

    final result = await ref.read(registerUseCaseProvider).call(
          RegisterParams(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        );

    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure;
      },
      (tokens) async {
        final userResult = await ref.read(getCurrentUserUseCaseProvider).call();
        return userResult.fold(
          (failure) {
            state = const AsyncData(null);
            return failure;
          },
          (user) {
            _identifyUser(user);
            state = AsyncData(user);
            return null;
          },
        );
      },
    );
  }

  Future<Failure?> updateUser({
    required String id,
    String? name,
    String? username,
  }) async {
    final result = await ref.read(updateUserUseCaseProvider).call(
          UpdateUserParams(id: id, name: name, username: username),
        );

    return result.fold(
      (failure) => failure,
      (user) {
        state = AsyncData(user);
        return null;
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(logoutUseCaseProvider).call();
    ref.read(analyticsProvider).reset();
    ref.read(errorReporterProvider).clearUser();
    state = const AsyncData(null);
  }

  void _identifyUser(User user) {
    ref.read(analyticsProvider).identify(
      userId: user.id,
      properties: {
        'email': user.email,
        if (user.displayName != user.email) 'name': user.displayName,
      },
    );
    ref.read(errorReporterProvider).setUser(
          id: user.id,
          email: user.email,
          name: user.displayName,
        );
  }
}
