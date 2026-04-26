import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/monitoring/error_reporter.dart';
import 'package:app_template/core/monitoring/sentry_error_reporter.dart';

final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => SentryErrorReporter(),
);
