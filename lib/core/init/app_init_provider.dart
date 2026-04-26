import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/l10n/locale_provider.dart';
import 'package:app_template/core/theme/theme_provider.dart';
import 'package:app_template/features/auth/presentation/providers/auth_notifier.dart';

/// Orchestrates app startup.
///
/// Waits for all required initialization to complete before
/// signalling that the app is ready to navigate away from splash.
///
/// Add future init steps here (settings, feature flags, etc.).
final appInitProvider = FutureProvider<void>((ref) async {
  // These run concurrently — each is an independent async init step.
  await Future.wait([
    ref.read(localeProvider.future),
    ref.read(themeModeProvider.future),
    ref.read(authNotifierProvider.future),
    // Future: settings, feature flags, remote config, etc.
  ]);
});
