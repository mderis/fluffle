import 'package:flutter/services.dart';

/// The build flavor the app was launched with.
///
/// Flavors are native (Android `productFlavors`, iOS schemes) and selected
/// with `flutter run --flavor <name>`. The Dart side reads the active one
/// from [appFlavor]. Each flavor installs side by side with its own
/// application id and display name.
enum Flavor {
  /// Local development against the dev backend.
  dev,

  /// QA builds against the staging backend.
  staging,

  /// Store builds against production.
  prod;

  /// The flavor of the running build.
  ///
  /// Falls back to [Flavor.dev] when no flavor is set, which only happens
  /// in unit and widget tests.
  static Flavor get current => switch (appFlavor) {
    'dev' || null => .dev,
    'staging' => .staging,
    'prod' => .prod,
    final other => throw StateError('Unknown flavor "$other".'),
  };

  /// Whether this is a production build.
  bool get isProd => this == .prod;
}
