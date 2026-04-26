import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_template/core/theme/app_effects.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_theme.dart';
import 'package:app_template/core/theme/app_typography.dart';
import 'package:app_template/l10n/app_localizations.dart';

/// Result of the image picker action sheet.
enum ImagePickerResult { camera, gallery, remove }

/// A glassmorphic bottom sheet for choosing an image source.
///
/// Use [AppImagePickerSheet.show] to display it. The sheet offers
/// "Take Photo", "Choose from Library", and optionally "Remove" options.
class AppImagePickerSheet extends StatelessWidget {
  final String title;
  final bool hasExistingImage;
  final String? removeLabel;
  final String? removeSubLabel;

  const AppImagePickerSheet({
    required this.title,
    this.hasExistingImage = false,
    this.removeLabel,
    this.removeSubLabel,
    super.key,
  });

  /// Shows the image picker action sheet and returns the user's choice.
  static Future<ImagePickerResult?> show({
    required BuildContext context,
    required String title,
    bool hasExistingImage = false,
    String? removeLabel,
    String? removeSubLabel,
  }) {
    HapticFeedback.mediumImpact();
    return showModalBottomSheet<ImagePickerResult>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: context.colors.scrim,
      isScrollControlled: true,
      builder: (_) => AppImagePickerSheet(
        title: title,
        hasExistingImage: hasExistingImage,
        removeLabel: removeLabel,
        removeSubLabel: removeSubLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final colors = context.colors;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppBlur.lg,
          sigmaY: AppBlur.lg,
        ),
        child: Container(
          color: colors.sheetBg,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.sheetHandle,
                    borderRadius: AppRadius.fullBorder,
                  ),
                ),

                // Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    bottom: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colors.divider,
                        width: AppStroke.thin,
                      ),
                    ),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSize.headline,
                      fontWeight: AppFontWeight.semiBold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),

                // Options
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Column(
                    children: [
                      _SheetOption(
                        icon: Icons.camera_alt_outlined,
                        label: l10n.takePhoto,
                        subLabel: l10n.useYourCamera,
                        iconBgColor: colors.successBg,
                        iconColor: colors.primary,
                        labelColor: colors.textPrimary,
                        onTap: () => Navigator.pop(
                          context,
                          ImagePickerResult.camera,
                        ),
                      ),
                      _SheetOption(
                        icon: Icons.photo_library_outlined,
                        label: l10n.chooseFromLibrary,
                        subLabel: l10n.pickExistingPhoto,
                        iconBgColor: colors.successBg,
                        iconColor: colors.primary,
                        labelColor: colors.textPrimary,
                        onTap: () => Navigator.pop(
                          context,
                          ImagePickerResult.gallery,
                        ),
                      ),
                      if (hasExistingImage)
                        _SheetOption(
                          icon: Icons.delete_outline,
                          label: removeLabel ?? l10n.removePhoto,
                          subLabel: removeSubLabel ?? l10n.resetToDefault,
                          iconBgColor: colors.errorBg,
                          iconColor: colors.error,
                          labelColor: colors.error,
                          onTap: () => Navigator.pop(
                            context,
                            ImagePickerResult.remove,
                          ),
                        ),
                    ],
                  ),
                ),

                // Cancel button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeightMd,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: colors.surface,
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.surfaceBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.smBorder,
                        ),
                        textStyle: const TextStyle(
                          fontSize: AppFontSize.body,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final Color iconBgColor;
  final Color iconColor;
  final Color labelColor;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.iconBgColor,
    required this.iconColor,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xl,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.iconContainer,
              height: AppSizes.iconContainer,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.iconLg,
                color: iconColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: AppFontWeight.medium,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subLabel,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
