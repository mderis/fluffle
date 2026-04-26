import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:sentry_dio/sentry_dio.dart';

import 'package:app_template/core/api/interceptors/auth_interceptor.dart';
import 'package:app_template/core/api/interceptors/error_interceptor.dart';
import 'package:app_template/core/api/interceptors/logging_interceptor.dart';
import 'package:app_template/core/api/interceptors/refresh_interceptor.dart';
import 'package:app_template/core/config/app_config_provider.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final loggerProvider = Provider<Logger>(
  (ref) => Logger(printer: PrettyPrinter(methodCount: 0)),
);

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(secureStorageProvider);
  final logger = ref.watch(loggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Order matters: auth → refresh → logging → error
  dio.interceptors.addAll([
    AuthInterceptor(storage: storage),
    RefreshInterceptor(dio: dio, storage: storage),
    if (!config.isProd) LoggingInterceptor(logger: logger),
    ErrorInterceptor(),
  ]);

  // Sentry must be added last
  dio.addSentry();

  return dio;
});
