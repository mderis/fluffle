import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:app_template/core/monitoring/error_reporter.dart';

class SentryErrorReporter implements ErrorReporter {
  @override
  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, dynamic>? extras,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: extras != null
          ? (scope) {
              for (final entry in extras.entries) {
                scope.setContexts(entry.key, entry.value);
              }
            }
          : null,
    );
  }

  @override
  Future<void> setUser({
    required String id,
    String? email,
    String? name,
  }) async {
    Sentry.configureScope(
      (scope) => scope.setUser(SentryUser(
        id: id,
        email: email,
        name: name,
      )),
    );
  }

  @override
  Future<void> clearUser() async {
    Sentry.configureScope((scope) => scope.setUser(null));
  }

  @override
  void setTag(String key, String value) {
    Sentry.configureScope((scope) => scope.setTag(key, value));
  }
}
