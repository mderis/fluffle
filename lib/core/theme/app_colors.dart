import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  Color get primary;
  Color get primaryLight;
  Color get primaryDark;

  // Background (solid scaffold base)
  Color get background;

  // Surface (cards, inputs, sheets)
  Color get surface;
  Color get surfaceBorder;

  // Text
  Color get textPrimary;
  Color get textSecondary;
  Color get textOnPrimary;
  Color get textHint;
  Color get textDisabled;
  Color get textLink;
  Color get textOnError;

  // Status / Semantic
  Color get error;
  Color get errorBg;
  Color get success;
  Color get successBg;
  Color get warning;
  Color get warningBg;
  Color get info;

  // Snackbar
  Color get snackbarBg;
  Color get snackbarText;
  Color get snackbarIcon;
  Color get snackbarAction;
  Color get snackbarSuccessBg;
  Color get snackbarErrorBg;
  Color get snackbarWarningBg;

  // Overlay / Scrim
  Color get scrim;
  Color get imageOverlay;

  // Divider
  Color get divider;

  // Shadow
  Color get shadow;

  // Shimmer / Loading
  Color get shimmerBase;
  Color get shimmerHighlight;

  // Badge
  Color get badge;

  // Bottom navigation
  Color get navBar;
  Color get navBarBorder;
  Color get navActive;
  Color get navInactive;

  // Input fields
  Color get inputBackground;
  Color get inputBorder;

  // Button
  Color get buttonPrimary;

  // Sheet
  Color get sheetBg;
  Color get sheetHandle;
}

class LightAppColors extends AppColors {
  @override
  Color get primary => const Color(0xFF1976D2);
  @override
  Color get primaryLight => const Color(0xFF64B5F6);
  @override
  Color get primaryDark => const Color(0xFF1565C0);

  @override
  Color get background => const Color(0xFFFAFAFA);

  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get surfaceBorder => const Color(0x14000000); // black 8%

  @override
  Color get textPrimary => const Color(0xDE000000); // black 87%
  @override
  Color get textSecondary => const Color(0x99000000); // black 60%
  @override
  Color get textOnPrimary => const Color(0xFFFFFFFF);
  @override
  Color get textHint => const Color(0x66000000); // black 40%
  @override
  Color get textDisabled => const Color(0x42000000); // black 26%
  @override
  Color get textLink => const Color(0xFF1976D2);
  @override
  Color get textOnError => const Color(0xFFFFFFFF);

  @override
  Color get error => const Color(0xFFD32F2F);
  @override
  Color get errorBg => const Color(0x14D32F2F); // 8%
  @override
  Color get success => const Color(0xFF2E7D32);
  @override
  Color get successBg => const Color(0x142E7D32); // 8%
  @override
  Color get warning => const Color(0xFFF9A825);
  @override
  Color get warningBg => const Color(0x14F9A825); // 8%
  @override
  Color get info => const Color(0xFF1565C0);

  @override
  Color get snackbarBg => const Color(0xE0212121);
  @override
  Color get snackbarText => const Color(0xEBFFFFFF);
  @override
  Color get snackbarIcon => const Color(0xBFFFFFFF); // white 75%
  @override
  Color get snackbarAction => const Color(0xFF64B5F6);
  @override
  Color get snackbarSuccessBg => const Color(0xE61B5E20);
  @override
  Color get snackbarErrorBg => const Color(0xE6501414);
  @override
  Color get snackbarWarningBg => const Color(0xE646320A);

  @override
  Color get scrim => const Color(0x52000000); // black 32%
  @override
  Color get imageOverlay => const Color(0x4D000000); // black 30%

  @override
  Color get divider => const Color(0x14000000); // black 8%

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get shimmerBase => const Color(0x14000000); // 8%
  @override
  Color get shimmerHighlight => const Color(0x05000000); // 2%

  @override
  Color get badge => const Color(0xFFD32F2F);

  @override
  Color get navBar => const Color(0xFFFFFFFF);
  @override
  Color get navBarBorder => const Color(0x0D000000); // black 5%
  @override
  Color get navActive => const Color(0xFF1976D2);
  @override
  Color get navInactive => const Color(0xFF9E9E9E);

  @override
  Color get inputBackground => const Color(0xFFF5F5F5);
  @override
  Color get inputBorder => const Color(0x14000000); // black 8%

  @override
  Color get buttonPrimary => const Color(0xFF1976D2);

  @override
  Color get sheetBg => const Color(0xFFFFFFFF);
  @override
  Color get sheetHandle => const Color(0x26000000); // black 15%
}

class DarkAppColors extends AppColors {
  @override
  Color get primary => const Color(0xFF64B5F6);
  @override
  Color get primaryLight => const Color(0xFF90CAF9);
  @override
  Color get primaryDark => const Color(0xFF1976D2);

  @override
  Color get background => const Color(0xFF121212);

  @override
  Color get surface => const Color(0xFF1E1E1E);
  @override
  Color get surfaceBorder => const Color(0x1FFFFFFF); // white 12%

  @override
  Color get textPrimary => const Color(0xDEFFFFFF); // white 87%
  @override
  Color get textSecondary => const Color(0x99FFFFFF); // white 60%
  @override
  Color get textOnPrimary => const Color(0xFF000000);
  @override
  Color get textHint => const Color(0x4DFFFFFF); // white 30%
  @override
  Color get textDisabled => const Color(0x33FFFFFF); // white 20%
  @override
  Color get textLink => const Color(0xFF64B5F6);
  @override
  Color get textOnError => const Color(0xFFFFFFFF);

  @override
  Color get error => const Color(0xFFEF5350);
  @override
  Color get errorBg => const Color(0x1AEF5350); // 10%
  @override
  Color get success => const Color(0xFF81C784);
  @override
  Color get successBg => const Color(0x1A81C784); // 10%
  @override
  Color get warning => const Color(0xFFFFD54F);
  @override
  Color get warningBg => const Color(0x1AFFD54F); // 10%
  @override
  Color get info => const Color(0xFF64B5F6);

  @override
  Color get snackbarBg => const Color(0x1FFFFFFF); // white 12%
  @override
  Color get snackbarText => const Color(0xE0FFFFFF);
  @override
  Color get snackbarIcon => const Color(0xA6FFFFFF); // white 65%
  @override
  Color get snackbarAction => const Color(0xFF64B5F6);
  @override
  Color get snackbarSuccessBg => const Color(0x2681C784); // 15%
  @override
  Color get snackbarErrorBg => const Color(0x26EF5350); // 15%
  @override
  Color get snackbarWarningBg => const Color(0x1AFFD54F); // 10%

  @override
  Color get scrim => const Color(0x66000000); // black 40%
  @override
  Color get imageOverlay => const Color(0x59000000); // black 35%

  @override
  Color get divider => const Color(0x1FFFFFFF); // white 12%

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get shimmerBase => const Color(0x14FFFFFF); // 8%
  @override
  Color get shimmerHighlight => const Color(0x05FFFFFF); // 2%

  @override
  Color get badge => const Color(0xFFEF5350);

  @override
  Color get navBar => const Color(0xFF1E1E1E);
  @override
  Color get navBarBorder => const Color(0x1FFFFFFF); // white 12%
  @override
  Color get navActive => const Color(0xFF64B5F6);
  @override
  Color get navInactive => const Color(0xFF757575);

  @override
  Color get inputBackground => const Color(0x14FFFFFF); // white 8%
  @override
  Color get inputBorder => const Color(0x1FFFFFFF); // white 12%

  @override
  Color get buttonPrimary => const Color(0xFF1976D2);

  @override
  Color get sheetBg => const Color(0xFF2A2A2A);
  @override
  Color get sheetHandle => const Color(0x33FFFFFF); // white 20%
}
