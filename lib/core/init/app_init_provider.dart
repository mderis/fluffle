import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/l10n/locale_notifier.dart';
import 'package:app_template/core/theme/theme_mode_notifier.dart';
import 'package:app_template/features/auth/auth.dart';

/// Orchestrates app startup.
///
/// Waits for all required initialization to complete before
/// signalling that the app is ready to navigate away from splash.
///
/// Add future init steps here (settings, feature flags, etc.).
final appInitProvider = FutureProvider<void>((ref) async {
  // These run concurrently — each is an independent async init step.
  await Future.wait([
    ref.read(localeNotifierProvider.future),
    ref.read(themeModeNotifierProvider.future),
    ref.read(authControllerProvider.future),
    // Future: settings, feature flags, remote config, etc.
  ]);
});
