# Fluffle: working notes for AI assistants

Fluffle is a production-ready Flutter starter template (iOS + Android). v2 is a
rebuild of the legacy template (tag `legacy-final`) on the newest Flutter.
Read `docs/decisions.md` before changing architecture, and
`docs/planning/fluffle-feature-inventory.md` for what is being ported.

## Platform baseline
- Flutter 3.47+, Dart 3.13 (`sdk: ^3.13.4`). Always prefer the newest APIs the
  SDK ships; check docs.flutter.dev / dart.dev when unsure.
- UI: standalone `material_ui` package. Import
  `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- Localization delegates are listed by hand in `lib/app/app.dart`
  (flutter/flutter#191072). Do not use `L10n.localizationsDelegates`.
- iOS 15+, Swift Package Manager, UIScene. Android AGP 9, Java 17,
  edge-to-edge and predictive back on.

## Commands (see `make help`)
- `make run FLAVOR=dev|staging|prod`: flavors are native (`--flavor`); config
  comes from `env/<flavor>.json` via `--dart-define-from-file`.
- `make gen` (gen-l10n + build_runner), `make analyze` (uses `dart analyze`,
  because `flutter analyze` hides analyzer-plugin diagnostics), `make test`.

## Code conventions
- Dart 3.13 style: primary constructors for data and value classes, dot
  shorthands (`.center`, `.all(16)`), null-aware elements, sealed classes and
  exhaustive `switch`.
- Riverpod 3 with `riverpod_generator` (`@riverpod`). Naming: `xxxProvider`
  for values, `XxxNotifier` holds state, `XxxController` runs operations.
- Repositories return `Result<T>` (`lib/core/result/`), never throw. `Failure`
  carries facts, not UI text; `failure.message(l10n)` localizes it.
- No hardcoded user-facing strings: everything goes through `L10n` (en + fa).
  Keep `app_fa.arb` complete. Use directional APIs (`EdgeInsetsDirectional`,
  `AlignmentDirectional`) so RTL works.
- No hardcoded colors, sizes or durations in widgets: use theme tokens.
- Features live in `lib/features/<name>/` with a public barrel
  `<name>.dart` and private `src/`. `core/` must never import `features/`.
  App wiring (router, bootstrap) lives in `lib/app/`.
- Config is not secret. Never put real secrets in `env/` or in the app.

## Documentation is part of every change
- Public APIs get dartdoc comments (why, not just what).
- Each feature gets a page under `docs/` and widget previews for shared UI.
- Record architecture decisions in `docs/decisions.md`.
- Writing style: plain, concise English. Never use em dashes.

## Commits
- Conventional commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`).
- Never commit `env/*.json` (except `env/example.json`) or generated code.
