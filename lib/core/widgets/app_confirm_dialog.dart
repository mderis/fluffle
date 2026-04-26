import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_template/core/theme/app_effects.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_styles.dart';
import 'package:app_template/core/theme/app_theme.dart';

/// Glassmorphic confirmation dialog with icon, title, body, and two actions.
///
/// ```dart
/// final discard = await AppConfirmDialog.show(
///   context: context,
///   icon: Icons.warning_amber_rounded,
///   title: l10n.discardChanges,
///   body: l10n.discardChangesBody,
///   confirmLabel: l10n.discard,
///   cancelLabel: l10n.keepEditing,
/// );
/// ```
class AppConfirmDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String confirmLabel;
  final String cancelLabel;

  const AppConfirmDialog({
    required this.icon,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.cancelLabel,
    super.key,
  });

  /// Shows the dialog and returns `true` if confirmed, `false` otherwise.
  static Future<bool> show({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    bool haptic = false,
  }) async {
    if (haptic) HapticFeedback.warningNotification();
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: cancelLabel,
      barrierColor: context.colors.scrim,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => AppConfirmDialog(
        icon: icon,
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
      ),
      transitionBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.dialogMaxWidth),
          child: ClipRRect(
            borderRadius: AppRadius.xlBorder,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: AppBlur.lg, sigmaY: AppBlur.lg),
              child: Material(
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.xlBorder,
                  side: BorderSide(color: colors.surfaceBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon circle
                      Container(
                        width: AppSpacing.page,
                        height: AppSpacing.page,
                        decoration: BoxDecoration(
                          color: colors.errorBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: AppSizes.iconXl,
                          color: colors.error,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Title
                      Text(
                        title,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // Body
                      Text(
                        body,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: AppButtonStyle.secondary(colors),
                              child: Text(cancelLabel),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: FilledButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: AppButtonStyle.solidDestructive(colors),
                              child: Text(confirmLabel),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
