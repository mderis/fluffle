import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_template/app.dart';
import 'package:app_template/core/config/app_config.dart';
import 'package:app_template/core/config/app_config_provider.dart';
import 'package:app_template/core/storage/shared_preferences_provider.dart';

Future<void> bootstrap(AppConfig config) async {
  SentryWidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // PostHog analytics
  final posthogConfig = PostHogConfig(config.posthogApiKey);
  posthogConfig.host = config.posthogHost;
  posthogConfig.captureApplicationLifecycleEvents = true;
  posthogConfig.debug = !config.isProd;
  await Posthog().setup(posthogConfig);

  // Sentry error reporting & performance monitoring
  await SentryFlutter.init(
    (options) {
      options.dsn = config.sentryDsn;
      options.environment = config.flavor.name;
      options.tracesSampleRate = config.isProd ? 0.3 : 1.0;
      options.enableAutoPerformanceTracing = true;
      options.enableUserInteractionTracing = true;
    },
    appRunner: () => runApp(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(config),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const App(),
      ),
    ),
  );
}
