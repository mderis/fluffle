import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/analytics/analytics_provider.dart';
import 'package:app_template/core/domain/entities/user.dart';
import 'package:app_template/core/domain/failures/failure.dart';
import 'package:app_template/core/monitoring/error_reporter_provider.dart';
import 'package:app_template/core/session/current_user_notifier.dart';
import 'package:app_template/features/auth/src/application/auth_providers.dart';

/// Owns auth *operations* (login, register, logout, profile update) and the
/// initial session restore. The current user itself lives in
/// [currentUserNotifierProvider] (in `core/session/`) — this controller writes to it.
///
/// State holds an [AsyncValue<void>]: `loading` while an op is in flight,
/// `data` when idle, `error` if `build()` failed. Read [currentUserNotifierProvider]
/// for "who is signed in".
final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    final result = await ref.read(authRepositoryProvider).getCurrentUser();
    result.fold((_) => _setUser(null), _setUser);
  }

  Future<Failure?> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure;
      },
      (_) => _loadAndSetUser(),
    );
  }

  Future<Failure?> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .register(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
    return result.fold(
      (failure) {
        state = const AsyncData(null);
        return failure;
      },
      (_) => _loadAndSetUser(),
    );
  }

  Future<Failure?> updateUser({
    required String id,
    String? name,
    String? username,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .updateUser(id: id, name: name, username: username);
    return result.fold((failure) => failure, (user) {
      _setUser(user);
      return null;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).logout();
    _setUser(null);
    state = const AsyncData(null);
  }

  Future<Failure?> _loadAndSetUser() async {
    final result = await ref.read(authRepositoryProvider).getCurrentUser();
    return result.fold(
      (failure) {
        _setUser(null);
        state = const AsyncData(null);
        return failure;
      },
      (user) {
        _setUser(user);
        state = const AsyncData(null);
        return null;
      },
    );
  }

  void _setUser(User? user) {
    ref.read(currentUserNotifierProvider.notifier).set(user);
    if (user != null) {
      ref
          .read(analyticsProvider)
          .identify(
            userId: user.id,
            properties: {
              'email': user.email,
              if (user.displayName != user.email) 'name': user.displayName,
            },
          );
      ref
          .read(errorReporterProvider)
          .setUser(id: user.id, email: user.email, name: user.displayName);
    } else {
      ref.read(analyticsProvider).reset();
      ref.read(errorReporterProvider).clearUser();
    }
  }
}
