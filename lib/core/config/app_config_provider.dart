import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/config/app_config.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError(
    'appConfigProvider must be overridden in bootstrap',
  ),
);
