import 'package:flutter/material.dart';

import 'package:app_template/core/theme/app_colors.dart';
import 'package:app_template/core/theme/app_effects.dart';
import 'package:app_template/core/theme/app_spacing.dart';

// ──────────────────────────────────────────────
//  BUTTON STYLES
// ──────────────────────────────────────────────

/// Reusable button style factory.
///
/// Use with standard Flutter buttons:
/// ```dart
/// OutlinedButton.icon(
///   style: AppButtonStyle.tinted(colors),
///   ...
/// )
/// ```
abstract class AppButtonStyle {
  /// Tinted background with subtle border.
  static ButtonStyle tinted(AppColors colors, {Color? color}) {
    final c = color ?? colors.primary;
    return OutlinedButton.styleFrom(
      foregroundColor: c,
      backgroundColor: c.withValues(alpha: AppOpacity.bgDecorLight),
      side: BorderSide(color: c.withValues(alpha: AppOpacity.glassBorder)),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
      minimumSize: const Size(0, AppSizes.buttonHeightSm),
    );
  }

  /// Destructive variant — tinted error for logout, delete, etc.
  static ButtonStyle destructive(AppColors colors) {
    return tinted(colors, color: colors.error);
  }

  /// Solid filled pill button — for primary actions like "Save".
  static ButtonStyle pill(AppColors colors, {Color? color}) {
    final c = color ?? colors.buttonPrimary;
    return FilledButton.styleFrom(
      foregroundColor: colors.textOnPrimary,
      backgroundColor: c,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.fullBorder),
      minimumSize: const Size(0, AppSizes.buttonHeightSm),
    );
  }

  /// Secondary — transparent background with surface border.
  static ButtonStyle secondary(AppColors colors) {
    return OutlinedButton.styleFrom(
      foregroundColor: colors.textPrimary,
      backgroundColor: Colors.transparent,
      side: BorderSide(color: colors.surfaceBorder),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.smBorder),
      minimumSize: const Size(0, AppSizes.buttonHeightMd),
    );
  }

  /// Solid destructive — filled error background for dangerous confirmations.
  static ButtonStyle solidDestructive(AppColors colors) {
    return FilledButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: colors.error,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.smBorder),
      minimumSize: const Size(0, AppSizes.buttonHeightMd),
    );
  }
}

// ──────────────────────────────────────────────
//  BOX STYLES
// ──────────────────────────────────────────────

/// Reusable box decoration factory.
///
/// ```dart
/// Container(
///   width: AppSizes.iconContainer,
///   height: AppSizes.iconContainer,
///   decoration: AppBoxStyle.iconPrimary(colors),
///   child: Icon(icon),
/// )
/// ```
abstract class AppBoxStyle {
  /// Primary-tinted icon container (e.g. account info rows).
  static BoxDecoration iconPrimary(AppColors colors) => BoxDecoration(
        color: colors.primary.withValues(alpha: AppOpacity.bgDecorLight),
        borderRadius: AppRadius.smBorder,
      );

  /// Neutral icon container (e.g. settings rows).
  static BoxDecoration iconNeutral(AppColors colors) => BoxDecoration(
        color: colors.surfaceBorder,
        borderRadius: AppRadius.smBorder,
      );
}
