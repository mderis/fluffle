import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/analytics/analytics_provider.dart';
import 'package:app_template/core/storage/shared_preferences_provider.dart';

const _themeModeKey = 'theme_mode';

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode?>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode?> {
  @override
  Future<ThemeMode?> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_themeModeKey);
    return _fromString(stored);
  }

  bool get hasChosenTheme => state.value != null;

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_themeModeKey, mode.name);
    state = AsyncData(mode);

    ref.read(analyticsProvider).registerSuperProperty('theme_mode', mode.name);
  }

  ThemeMode? _fromString(String? value) => switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => null,
      };
}
