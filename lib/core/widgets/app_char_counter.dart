import 'package:flutter/material.dart';

import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/core/theme/app_typography.dart';
import 'package:app_template/l10n/app_localizations.dart';

/// Character counter with normal/warning/over color states.
///
/// ```dart
/// AppCharCounter(current: 28, max: 30)
/// ```
class AppCharCounter extends StatelessWidget {
  final int current;
  final int max;
  final double warningThreshold;

  const AppCharCounter({
    required this.current,
    required this.max,
    this.warningThreshold = 0.8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Color color;

    if (current > max) {
      color = colors.error;
    } else if (current >= (max * warningThreshold).round()) {
      color = colors.warning;
    } else {
      color = colors.textHint;
    }

    return Text(
      L10n.of(context).charCounter(current, max),
      style: TextStyle(
        fontSize: AppFontSize.caption,
        color: color,
      ),
    );
  }
}
