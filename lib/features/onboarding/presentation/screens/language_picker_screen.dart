import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/l10n/locale_provider.dart';
import 'package:app_template/core/l10n/supported_locales.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_typography.dart';
import 'package:app_template/l10n/app_localizations.dart';

class LanguagePickerScreen extends ConsumerWidget {
  const LanguagePickerScreen({super.key});

  static const _languages = [
    _LanguageOption(locale: SupportedLocales.en, flag: '🇬🇧', name: 'English'),
    _LanguageOption(locale: SupportedLocales.fa, flag: '🇮🇷', name: 'فارسی'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language,
                  size: AppSpacing.hero,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.chooseLanguage,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.chooseLanguageSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                ..._languages.map(
                  (lang) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: AppSpacing.sm),
                    child: _LanguageTile(
                      option: lang,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref
                            .read(localeProvider.notifier)
                            .setLocale(lang.locale);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final _LanguageOption option;
  final VoidCallback onTap;

  const _LanguageTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = SupportedLocales.isRtl(option.locale);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.mdBorder,
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorder,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Text(option.flag,
                  style: const TextStyle(fontSize: AppFontSize.largeTitle)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  option.name,
                  style: theme.textTheme.titleMedium,
                  textDirection:
                      isRtl ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  final Locale locale;
  final String flag;
  final String name;

  const _LanguageOption({
    required this.locale,
    required this.flag,
    required this.name,
  });
}
