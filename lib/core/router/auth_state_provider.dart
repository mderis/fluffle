import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/features/auth/presentation/providers/auth_notifier.dart';

/// Derived from [authNotifierProvider] — always in sync, no manual updates needed.
final authStateProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).value != null;
});
