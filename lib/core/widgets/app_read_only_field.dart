import 'package:flutter/material.dart';

import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/core/theme/app_typography.dart';
import 'package:app_template/core/utils/app_clipboard.dart';

/// A read-only field with label. Tapping copies the value to clipboard by default.
///
/// ```dart
/// AppReadOnlyField(label: l10n.email, value: user.email)
/// AppReadOnlyField(label: l10n.userId, value: user.id, copyable: false)
/// ```
class AppReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;

  const AppReadOnlyField({
    required this.label,
    required this.value,
    this.copyable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final inputTheme = Theme.of(context).inputDecorationTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppFontSize.footnote,
              fontWeight: AppFontWeight.medium,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ),
        GestureDetector(
          onTap: copyable ? () => _copyToClipboard(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: inputTheme.fillColor,
              border: inputTheme.border,
              enabledBorder: inputTheme.enabledBorder,
              contentPadding: inputTheme.contentPadding,
              suffixIcon: copyable
                  ? Icon(
                      Icons.copy,
                      size: AppSizes.iconSm.toDouble(),
                      color: colors.textDisabled,
                    )
                  : null,
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSize.body,
                color: colors.textDisabled,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    AppClipboard.copy(context, label: label, value: value);
  }
}
