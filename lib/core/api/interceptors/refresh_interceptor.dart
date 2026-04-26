import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RefreshInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  RefreshInterceptor({required Dio dio, required FlutterSecureStorage storage})
    : _dio = dio,
      _storage = storage;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null) {
      return handler.next(err);
    }

    try {
      // Use a fresh Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String?;

      await _storage.write(key: _accessTokenKey, value: newAccessToken);
      if (newRefreshToken != null) {
        await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
      }

      // Retry the original request with the new token
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _dio.fetch(options);
      return handler.resolve(retryResponse);
    } on DioException {
      // Refresh failed — clear tokens and propagate
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      return handler.next(err);
    }
  }
}
