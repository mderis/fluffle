import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'API_BASE_URL')
  static const String apiBaseUrl = _EnvDev.apiBaseUrl;

  @EnviedField(varName: 'AUTH_CLIENT_ID', obfuscate: true)
  static final String authClientId = _EnvDev.authClientId;

  @EnviedField(varName: 'AUTH_CLIENT_SECRET', obfuscate: true)
  static final String authClientSecret = _EnvDev.authClientSecret;

  @EnviedField(varName: 'POSTHOG_API_KEY', obfuscate: true)
  static final String posthogApiKey = _EnvDev.posthogApiKey;

  @EnviedField(varName: 'POSTHOG_HOST')
  static const String posthogHost = _EnvDev.posthogHost;

  @EnviedField(varName: 'SENTRY_DSN')
  static const String sentryDsn = _EnvDev.sentryDsn;
}
