import 'dart:ui';

class SupportedLocales {
  SupportedLocales._();

  static const en = Locale('en');
  static const fa = Locale('fa');

  static const all = [en, fa];

  static final rtlLocales = {fa};

  static bool isRtl(Locale locale) => rtlLocales.contains(locale);
}
