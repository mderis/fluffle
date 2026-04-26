import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
//  OPACITY
// ──────────────────────────────────────────────

/// Opacity tokens for glassmorphism, disabled states, overlays.
abstract class AppOpacity {
  // Glass / frost effects
  static const double glassBgLight = 0.65;
  static const double glassBgDark = 0.40;
  static const double glassBorder = 0.18;

  // Decorative background elements
  static const double bgDecorLight = 0.06;
  static const double bgDecorDark = 0.10;

  // State
  static const double disabled = 0.38;
  static const double hint = 0.50;
  static const double secondary = 0.65;
  static const double primary = 0.87;
  static const double full = 1.0;

  // Overlay
  static const double scrim = 0.40;
  static const double imageOverlay = 0.30;
  static const double coverEditOverlay = 0.50;
}

// ──────────────────────────────────────────────
//  BLUR
// ──────────────────────────────────────────────

/// Blur values for glassmorphic effects.
abstract class AppBlur {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 40;
  static const double glass = 20;
}

// ──────────────────────────────────────────────
//  SHADOWS
// ──────────────────────────────────────────────

/// Shadow presets.
///
/// Pass [color] (typically `context.colors.shadow`) for themed tinting.
/// Falls back to black when no color is provided.
abstract class AppShadow {
  static List<BoxShadow> sm({Color color = Colors.black}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> md({Color color = Colors.black}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> lg({Color color = Colors.black}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> elevated({Color color = Colors.black}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.10),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}

// ──────────────────────────────────────────────
//  STROKE / BORDERS
// ──────────────────────────────────────────────

/// Border width tokens.
abstract class AppStroke {
  static const double thin = 0.5;
  static const double regular = 1.0;
  static const double medium = 1.5;
  static const double thick = 2.0;
  static const double heavy = 3.0;
}
