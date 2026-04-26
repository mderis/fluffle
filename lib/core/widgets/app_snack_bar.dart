import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_template/core/theme/app_colors.dart';
import 'package:app_template/core/theme/app_motion.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/core/theme/app_typography.dart';

/// Snackbar action data.
class AppSnackBarAction {
  final String label;
  final VoidCallback onPressed;

  const AppSnackBarAction({required this.label, required this.onPressed});
}

/// Centralized snackbar system.
///
/// ```dart
/// AppSnackBar.success(context, message: 'Profile updated');
/// AppSnackBar.error(context, message: 'Failed to save', action: AppSnackBarAction(label: 'Retry', onPressed: _retry));
/// AppSnackBar.success(context, message: l10n.copiedToClipboard, haptic: true);
/// ```
abstract class AppSnackBar {
  /// Show a success snackbar.
  static void success(
    BuildContext context, {
    required String message,
    AppSnackBarAction? action,
    bool haptic = false,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      variant: _Variant.success,
      duration: AppDuration.snackbarSuccess,
      action: action,
      haptic: haptic,
      dismissible: dismissible,
    );
  }

  /// Show an info snackbar.
  static void info(
    BuildContext context, {
    required String message,
    AppSnackBarAction? action,
    bool haptic = false,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.info_outline,
      variant: _Variant.info,
      duration: AppDuration.snackbarInfo,
      action: action,
      haptic: haptic,
      dismissible: dismissible,
    );
  }

  /// Show a warning snackbar.
  static void warning(
    BuildContext context, {
    required String message,
    AppSnackBarAction? action,
    bool haptic = false,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.warning_amber_rounded,
      variant: _Variant.warning,
      duration: AppDuration.snackbarWarning,
      action: action,
      haptic: haptic,
      dismissible: dismissible,
    );
  }

  /// Show an error snackbar.
  static void error(
    BuildContext context, {
    required String message,
    AppSnackBarAction? action,
    bool haptic = false,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      icon: Icons.cancel_outlined,
      variant: _Variant.error,
      duration: AppDuration.snackbarError,
      action: action,
      haptic: haptic,
      dismissible: dismissible,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required _Variant variant,
    required Duration duration,
    AppSnackBarAction? action,
    bool haptic = false,
    bool dismissible = true,
  }) {
    if (haptic) HapticFeedback.lightImpact();

    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconXl.toDouble(),
              color: _iconColor(colors, variant),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: AppFontSize.body2,
                  fontWeight: AppFontWeight.medium,
                  color: colors.snackbarText,
                ),
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: () {
                  action.onPressed();
                  messenger.hideCurrentSnackBar();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  child: Text(
                    action.label,
                    style: TextStyle(
                      fontSize: AppFontSize.body2,
                      fontWeight: AppFontWeight.semiBold,
                      color: colors.snackbarAction,
                      letterSpacing: AppLetterSpacing.wide,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: _backgroundColor(colors, variant),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdBorder),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        duration: duration,
        dismissDirection: dismissible
            ? DismissDirection.down
            : DismissDirection.none,
      ),
    );
  }

  static Color _backgroundColor(AppColors colors, _Variant variant) =>
      switch (variant) {
        _Variant.success => colors.snackbarSuccessBg,
        _Variant.error => colors.snackbarErrorBg,
        _Variant.warning => colors.snackbarWarningBg,
        _Variant.info => colors.snackbarBg,
      };

  static Color _iconColor(AppColors colors, _Variant variant) =>
      switch (variant) {
        _Variant.success => colors.success,
        _Variant.error => colors.error,
        _Variant.warning => colors.warning,
        _Variant.info => colors.snackbarIcon,
      };
}

enum _Variant { info, success, error, warning }
