import 'package:fluffle/core/config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config_provider.g.dart';

/// The [AppConfig] of the running build.
///
/// Always overridden in `bootstrap()`; reading it anywhere else without an
/// override is a programming error.
@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => throw UnimplementedError(
  'appConfigProvider must be overridden in bootstrap().',
);
