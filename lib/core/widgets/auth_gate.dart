import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/features/auth/presentation/providers/auth_notifier.dart';

/// Shows [authenticated] when user is logged in, [unauthenticated] otherwise.
///
/// Reacts to auth state changes — automatically switches when user logs in/out.
class AuthGate extends ConsumerWidget {
  final Widget authenticated;
  final Widget unauthenticated;

  const AuthGate({
    required this.authenticated,
    required this.unauthenticated,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).value;
    return user != null ? authenticated : unauthenticated;
  }
}
