import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
//  FONT SIZES
// ──────────────────────────────────────────────

/// Font size scale.
abstract class AppFontSize {
  static const double caption = 11;
  static const double footnote = 12;
  static const double body2 = 13;
  static const double body = 14;
  static const double subhead = 15;
  static const double headline = 16;
  static const double title3 = 18;
  static const double title2 = 20;
  static const double title1 = 24;
  static const double largeTitle = 28;
  static const double display = 34;
}

// ──────────────────────────────────────────────
//  LINE HEIGHT
// ──────────────────────────────────────────────

/// Line height multipliers (relative to font size).
abstract class AppLineHeight {
  static const double tight = 1.15;
  static const double normal = 1.35;
  static const double relaxed = 1.5;
  static const double loose = 1.7;
}

// ──────────────────────────────────────────────
//  LETTER SPACING
// ──────────────────────────────────────────────

/// Letter spacing values.
abstract class AppLetterSpacing {
  static const double tight = -0.5;
  static const double normal = 0.0;
  static const double wide = 0.3;
  static const double wider = 0.6;
  static const double sectionTitle = 1.2;
}

// ──────────────────────────────────────────────
//  FONT WEIGHT
// ──────────────────────────────────────────────

/// Font weight aliases for readability.
abstract class AppFontWeight {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}
