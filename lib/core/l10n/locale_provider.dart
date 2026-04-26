import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/analytics/analytics_provider.dart';
import 'package:app_template/core/l10n/supported_locales.dart';
import 'package:app_template/core/monitoring/error_reporter_provider.dart';
import 'package:app_template/core/storage/shared_preferences_provider.dart';

const _localeKey = 'locale';

final localeProvider =
    AsyncNotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);

class LocaleNotifier extends AsyncNotifier<Locale?> {
  @override
  Future<Locale?> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_localeKey);
    if (stored == null) return null;
    return _fromLanguageCode(stored);
  }

  bool get hasChosenLocale => state.value != null;

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_localeKey, locale.languageCode);
    state = AsyncData(locale);

    ref
        .read(analyticsProvider)
        .registerSuperProperty('language', locale.languageCode);
    ref.read(errorReporterProvider).setTag('language', locale.languageCode);
  }

  Locale? _fromLanguageCode(String code) {
    final match = SupportedLocales.all.where(
      (l) => l.languageCode == code,
    );
    return match.isEmpty ? null : match.first;
  }
}
