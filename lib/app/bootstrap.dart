import 'package:fluffle/app/app.dart';
import 'package:fluffle/core/config/app_config.dart';
import 'package:fluffle/core/config/app_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// Starts the app.
///
/// Everything that must exist before the first frame is created here and
/// injected into the [ProviderScope] as overrides, so the rest of the app
/// can read it synchronously. Monitoring and analytics are added here in
/// later steps.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const App(),
    ),
  );
}
