import 'package:app_template/core/config/env/env_dev.dart';
import 'package:app_template/core/config/env/env_prod.dart';
import 'package:app_template/core/config/flavor.dart';

class AppConfig {
  final Flavor flavor;
  final String apiBaseUrl;
  final String authClientId;
  final String authClientSecret;
  final String posthogApiKey;
  final String posthogHost;
  final String sentryDsn;

  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.authClientId,
    required this.authClientSecret,
    required this.posthogApiKey,
    required this.posthogHost,
    required this.sentryDsn,
  });

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;

  factory AppConfig.dev() => AppConfig(
        flavor: Flavor.dev,
        apiBaseUrl: EnvDev.apiBaseUrl,
        authClientId: EnvDev.authClientId,
        authClientSecret: EnvDev.authClientSecret,
        posthogApiKey: EnvDev.posthogApiKey,
        posthogHost: EnvDev.posthogHost,
        sentryDsn: EnvDev.sentryDsn,
      );

  factory AppConfig.prod() => AppConfig(
        flavor: Flavor.prod,
        apiBaseUrl: EnvProd.apiBaseUrl,
        authClientId: EnvProd.authClientId,
        authClientSecret: EnvProd.authClientSecret,
        posthogApiKey: EnvProd.posthogApiKey,
        posthogHost: EnvProd.posthogHost,
        sentryDsn: EnvProd.sentryDsn,
      );
}
