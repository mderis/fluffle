abstract class ErrorReporter {
  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, dynamic>? extras,
  });

  Future<void> setUser({required String id, String? email, String? name});

  Future<void> clearUser();

  void setTag(String key, String value);
}
