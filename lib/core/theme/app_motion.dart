import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
//  DURATION
// ──────────────────────────────────────────────

/// Duration tokens for consistent motion.
abstract class AppDuration {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 450);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration themeSwitch = Duration(milliseconds: 400);
  static const Duration shimmer = Duration(milliseconds: 1500);

  // Snackbar display durations
  static const Duration snackbarInfo = Duration(milliseconds: 2000);
  static const Duration snackbarSuccess = Duration(milliseconds: 2000);
  static const Duration snackbarWarning = Duration(milliseconds: 3000);
  static const Duration snackbarError = Duration(milliseconds: 4000);
}

// ──────────────────────────────────────────────
//  CURVES
// ──────────────────────────────────────────────

/// Curve presets for animations.
abstract class AppCurve {
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve spring = Curves.elasticOut;
  static const Curve overshoot = Curves.easeOutBack;
  static const Curve emphasized = Curves.easeOutCubic;
}
