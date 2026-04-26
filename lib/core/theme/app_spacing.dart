import 'package:flutter/material.dart';

// ──────────────────────────────────────────────
//  SPACING
// ──────────────────────────────────────────────

/// Consistent spacing scale (4px base grid).
abstract class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 28;
  static const double xxxl = 32;

  static const double listBottomPadding = xxxl * 3;

  static const double section = 40;
  static const double page = 48;
  static const double hero = 64;

  /// Common EdgeInsets presets.
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets paddingVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVLg = EdgeInsets.symmetric(vertical: lg);

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}

// ──────────────────────────────────────────────
//  BORDER RADIUS
// ──────────────────────────────────────────────

/// Consistent border radius scale.
abstract class AppRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;

  static BorderRadius get xsBorder => BorderRadius.circular(xs);
  static BorderRadius get smBorder => BorderRadius.circular(sm);
  static BorderRadius get mdBorder => BorderRadius.circular(md);
  static BorderRadius get lgBorder => BorderRadius.circular(lg);
  static BorderRadius get xlBorder => BorderRadius.circular(xl);
  static BorderRadius get xxlBorder => BorderRadius.circular(xxl);
  static BorderRadius get fullBorder => BorderRadius.circular(full);

  static BorderRadius topMd = const BorderRadius.vertical(
    top: Radius.circular(md),
  );
  static BorderRadius topLg = const BorderRadius.vertical(
    top: Radius.circular(lg),
  );
  static BorderRadius bottomLg = const BorderRadius.vertical(
    bottom: Radius.circular(lg),
  );
}

// ──────────────────────────────────────────────
//  SIZES
// ──────────────────────────────────────────────

/// Standard sizes used throughout the app.
abstract class AppSizes {
  // ── Icons ──
  static const double iconXs = 12;
  static const double iconSm = 14;
  static const double iconMd = 16;
  static const double iconLg = 18;
  static const double iconXl = 22;
  static const double iconXxl = 26;
  static const double iconContainer = 36;

  // ── Avatars ──
  static const double avatarSm = 28;
  static const double avatarMd = 36;
  static const double avatarLg = 48;
  static const double avatarXl = 82;

  // ── Buttons ──
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // ── Inputs ──
  static const double inputHeight = 48;
  static const double searchBarHeight = 44;

  // ── Navigation ──
  static const double bottomNavHeight = 64;
  static const double appBarHeight = 56;

  // ── Divider ──
  static const double dividerThin = 0.5;
  static const double dividerThick = 1.0;

  // ── Dialog ──
  static const double dialogMaxWidth = 300;
}
