import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_template/core/theme/app_colors.dart';
import 'package:app_template/core/theme/app_effects.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/theme/app_typography.dart';

class AppTheme {
  AppTheme._();

  static final _light = LightAppColors();
  static final _dark = DarkAppColors();

  static ThemeData light() => _build(_light, Brightness.light);
  static ThemeData dark() => _build(_dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.primary,
        onPrimary: c.textOnPrimary,
        secondary: c.primaryLight,
        onSecondary: c.textOnPrimary,
        error: c.error,
        onError: c.textOnError,
        surface: c.surface,
        onSurface: c.textPrimary,
        surfaceContainerHighest: c.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: c.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.navBar,
        indicatorColor: c.navActive.withValues(alpha: isLight ? 0.12 : 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: c.navActive,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            );
          }
          return TextStyle(color: c.navInactive, fontSize: 11);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.navActive, size: 22);
          }
          return IconThemeData(color: c.navInactive, size: 22);
        }),
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdBorder,
          side: BorderSide(color: c.surfaceBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.inputBackground,
        border: OutlineInputBorder(
          borderRadius: AppRadius.smBorder,
          borderSide: BorderSide(color: c.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.smBorder,
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.smBorder,
          borderSide: BorderSide(color: c.primary, width: AppStroke.medium),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        hintStyle: TextStyle(color: c.textHint),
        helperStyle: TextStyle(color: c.textHint),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.buttonPrimary,
          foregroundColor: c.textOnPrimary,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdBorder,
          ),
          textStyle: TextStyle(
            fontSize: AppFontSize.headline,
            fontWeight: AppFontWeight.semiBold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.divider,
        thickness: AppStroke.regular,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.largeTitle,
          fontWeight: AppFontWeight.semiBold,
        ),
        headlineMedium: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.title2,
          fontWeight: AppFontWeight.semiBold,
        ),
        titleLarge: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.title3,
          fontWeight: AppFontWeight.semiBold,
        ),
        titleMedium: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.headline,
          fontWeight: AppFontWeight.medium,
        ),
        titleSmall: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.body2,
          fontWeight: AppFontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.headline,
        ),
        bodyMedium: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.body,
        ),
        bodySmall: TextStyle(
          color: c.textSecondary,
          fontSize: AppFontSize.footnote,
        ),
        labelLarge: TextStyle(
          color: c.textPrimary,
          fontSize: AppFontSize.body,
          fontWeight: AppFontWeight.medium,
        ),
        labelMedium: TextStyle(
          color: c.textSecondary,
          fontSize: AppFontSize.caption,
          fontWeight: AppFontWeight.semiBold,
        ),
        labelSmall: TextStyle(
          color: c.textSecondary,
          fontSize: 10,
          letterSpacing: AppLetterSpacing.wide,
        ),
      ),
      extensions: [
        AppColorsExtension(c),
      ],
    );
  }
}

/// ThemeExtension to access AppColors from BuildContext.
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final AppColors colors;

  const AppColorsExtension(this.colors);

  @override
  AppColorsExtension copyWith({AppColors? colors}) =>
      AppColorsExtension(colors ?? this.colors);

  @override
  AppColorsExtension lerp(covariant ThemeExtension<AppColorsExtension>? other,
      double t) {
    return this;
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColorsExtension>()!.colors;
}
