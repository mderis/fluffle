import 'package:flutter/material.dart';

import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt_rounded,
              size: AppSpacing.hero,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              L10n.of(context).appTitle,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: AppSpacing.xl,
              height: AppSpacing.xl,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
