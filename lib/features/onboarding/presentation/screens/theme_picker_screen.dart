import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/theme_provider.dart';
import 'package:app_template/l10n/app_localizations.dart';

class ThemePickerScreen extends ConsumerWidget {
  const ThemePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    final options = <_ThemeOption>[
      _ThemeOption(
        mode: ThemeMode.system,
        icon: Icons.brightness_auto,
        name: l10n.themeSystem,
      ),
      _ThemeOption(
        mode: ThemeMode.light,
        icon: Icons.light_mode_outlined,
        name: l10n.themeLight,
      ),
      _ThemeOption(
        mode: ThemeMode.dark,
        icon: Icons.dark_mode_outlined,
        name: l10n.themeDark,
      ),
    ];

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
                  Icons.palette_outlined,
                  size: AppSpacing.hero,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  l10n.chooseTheme,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.chooseThemeSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                ...options.map(
                  (opt) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                        bottom: AppSpacing.sm),
                    child: _ThemeTile(
                      option: opt,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(opt.mode);
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

class _ThemeTile extends StatelessWidget {
  final _ThemeOption option;
  final VoidCallback onTap;

  const _ThemeTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Icon(option.icon, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(option.name, style: theme.textTheme.titleMedium),
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

class _ThemeOption {
  final ThemeMode mode;
  final IconData icon;
  final String name;

  const _ThemeOption({
    required this.mode,
    required this.icon,
    required this.name,
  });
}
