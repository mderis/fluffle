import 'package:fluffle/core/config/flavor.dart';

/// Runtime configuration for the current build.
///
/// Values come from `--dart-define-from-file=env/<flavor>.json` and are
/// compiled into the binary as plain strings. Nothing here is secret:
/// API URLs, client ids, the PostHog project key and the Sentry DSN are all
/// designed to ship inside client apps. Never put a real secret in `env/`.
///
/// See `env/example.json` for the expected keys.
class const AppConfig({
  required final Flavor flavor,
  required final String apiBaseUrl,
  required final String authClientId,
  required final String posthogApiKey,
  required final String posthogHost,
  required final String sentryDsn,
}) {
  /// Reads the configuration compiled in via `--dart-define-from-file`.
  ///
  /// Throws a [StateError] when a required value is missing, so a build
  /// started without an env file fails loudly at launch instead of later
  /// with a confusing network error.
  factory fromEnvironment() {
    const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is not set. Run with '
        '--dart-define-from-file=env/<flavor>.json (see env/example.json).',
      );
    }
    return AppConfig(
      flavor: Flavor.current,
      apiBaseUrl: apiBaseUrl,
      authClientId: const String.fromEnvironment('AUTH_CLIENT_ID'),
      posthogApiKey: const String.fromEnvironment('POSTHOG_API_KEY'),
      posthogHost: const String.fromEnvironment('POSTHOG_HOST'),
      sentryDsn: const String.fromEnvironment('SENTRY_DSN'),
    );
  }

  /// Whether analytics should be sent for this build.
  bool get hasAnalytics => posthogApiKey.isNotEmpty;

  /// Whether crash reporting should be enabled for this build.
  bool get hasCrashReporting => sentryDsn.isNotEmpty;
}
