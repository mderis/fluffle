import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/domain/entities/user.dart';

/// The currently signed-in user, or `null` if signed out.
///
/// This provider is the **single source of truth** for "who is logged in"
/// across the whole app. Any feature can read it; only the auth feature
/// should write to it (via [CurrentUserNotifier.set]).
///
/// Lives in `core/` because session identity is cross-cutting state — many
/// features need to read it, but it doesn't belong to any one feature.
final currentUserNotifierProvider = NotifierProvider<CurrentUserNotifier, User?>(
  CurrentUserNotifier.new,
);

class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  /// Replace the current user. Pass `null` to sign out.
  void set(User? user) => state = user;
}

/// Convenience: `true` when a user is signed in.
final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(currentUserNotifierProvider) != null,
);
