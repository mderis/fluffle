import 'package:fluffle/app/bootstrap.dart';

/// Entry point for every flavor.
///
/// The flavor comes from `--flavor`, the configuration from
/// `--dart-define-from-file=env/<flavor>.json`. Use `make run` or the
/// shared IDE run configurations instead of typing these by hand.
Future<void> main() => bootstrap();
