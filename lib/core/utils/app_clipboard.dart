import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_template/core/analytics/analytics_provider.dart';
import 'package:app_template/core/widgets/app_snack_bar.dart';
import 'package:app_template/l10n/app_localizations.dart';

/// Copies [value] to the clipboard, shows a success snackbar, and tracks the event.
///
/// [label] identifies what was copied (e.g. 'Email', 'User ID') for analytics.
///
/// ```dart
/// AppClipboard.copy(context, label: 'Email', value: user.email);
/// ```
class AppClipboard {
  AppClipboard._();

  static void copy(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    Clipboard.setData(ClipboardData(text: value));
    AppSnackBar.success(
      context,
      message: L10n.of(context).copiedToClipboard,
      haptic: true,
    );

    ProviderScope.containerOf(context)
        .read(analyticsProvider)
        .track(event: 'text_copied', properties: {'label': label});
  }
}
