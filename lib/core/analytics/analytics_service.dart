abstract class AnalyticsService {
  Future<void> identify({
    required String userId,
    Map<String, Object>? properties,
  });

  Future<void> track({required String event, Map<String, Object>? properties});

  Future<void> screen({required String name, Map<String, Object>? properties});

  Future<void> setUserProperties(Map<String, Object> properties);

  Future<void> registerSuperProperty(String key, Object value);

  Future<void> unregisterSuperProperty(String key);

  Future<void> reset();
}
