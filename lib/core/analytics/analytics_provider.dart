import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/analytics/analytics_service.dart';
import 'package:app_template/core/analytics/posthog_analytics_service.dart';

final analyticsProvider = Provider<AnalyticsService>(
  (ref) => PostHogAnalyticsService(),
);
