import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'API_BASE_URL')
  static const String apiBaseUrl = _EnvProd.apiBaseUrl;

  @EnviedField(varName: 'AUTH_CLIENT_ID', obfuscate: true)
  static final String authClientId = _EnvProd.authClientId;

  @EnviedField(varName: 'AUTH_CLIENT_SECRET', obfuscate: true)
  static final String authClientSecret = _EnvProd.authClientSecret;

  @EnviedField(varName: 'POSTHOG_API_KEY', obfuscate: true)
  static final String posthogApiKey = _EnvProd.posthogApiKey;

  @EnviedField(varName: 'POSTHOG_HOST')
  static const String posthogHost = _EnvProd.posthogHost;

  @EnviedField(varName: 'SENTRY_DSN')
  static const String sentryDsn = _EnvProd.sentryDsn;
}
