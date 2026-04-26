import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:app_template/core/analytics/analytics_service.dart';

class PostHogAnalyticsService implements AnalyticsService {
  final Posthog _posthog;

  PostHogAnalyticsService({Posthog? posthog}) : _posthog = posthog ?? Posthog();

  @override
  Future<void> identify({
    required String userId,
    Map<String, Object>? properties,
  }) async {
    await _posthog.identify(userId: userId, userProperties: properties);
  }

  @override
  Future<void> track({
    required String event,
    Map<String, Object>? properties,
  }) async {
    await _posthog.capture(eventName: event, properties: properties);
  }

  @override
  Future<void> screen({
    required String name,
    Map<String, Object>? properties,
  }) async {
    await _posthog.screen(screenName: name, properties: properties);
  }

  @override
  Future<void> setUserProperties(Map<String, Object> properties) async {
    await _posthog.setPersonProperties(userPropertiesToSet: properties);
  }

  @override
  Future<void> registerSuperProperty(String key, Object value) async {
    await _posthog.register(key, value);
  }

  @override
  Future<void> unregisterSuperProperty(String key) async {
    await _posthog.unregister(key);
  }

  @override
  Future<void> reset() async {
    await _posthog.reset();
  }
}
