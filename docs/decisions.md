# Architecture decisions

Short records of decisions that shape the template. Newest last. Each entry
says what we chose, why, and what we gave up.

## 001. Rebuild v2 from a fresh scaffold (2026-09-27)
The legacy template is kept at tag `legacy-final`. v2 starts from
`flutter create` on Flutter 3.47 so native projects (SwiftPM, UIScene, AGP 9)
are correct from day one, and features are ported one by one.

## 002. Standalone `material_ui` (2026-09-27)
Material moved out of the SDK into `material_ui` (1.x). We import it
everywhere. The gen-l10n delegate list is broken with it
(flutter/flutter#191072), so delegates are listed by hand in `App`.
If a dependency still uses the SDK Material library, wrap the app with
`MaterialUiCompatibilityBridge` in `MaterialApp.builder`.

## 003. Native flavors: dev, staging, prod (2026-09-27)
Android `productFlavors` and iOS schemes, each with its own application id
(`.dev`, `.stg`, none) and display name, so all three install side by side.
Dart reads the flavor from `appFlavor`. `default-flavor: dev` in pubspec.

## 004. Config via `--dart-define-from-file`, no obfuscation (2026-09-27)
`env/<flavor>.json` (gitignored, `env/example.json` committed), read with
`String.fromEnvironment`. No codegen. Obfuscation (envied) only slowed down
extraction and gave a false sense of security; none of our config values are
secret (API URL, client id, PostHog project key, Sentry DSN are designed to be
public). Real secrets never ship in the app.

## 005. Auth: password grant with a public client (2026-09-27)
Native login forms, Laravel Passport password grant, no client secret in the
app. The backend must expose a public (secret-less) password client. PKCE can
be added later if SSO or social login is needed.

## 006. Errors: own sealed `Result<T>` and `Failure` (2026-09-27)
Replaces fpdart `Either` (v2 stalled, extra dependency). Matches the Result
pattern in Flutter's architecture guide. `Failure` holds facts only; the UI
localizes them via `failure.message(l10n)`.

## 007. Riverpod 3 with code generation (2026-09-27)
`riverpod_generator` + `riverpod_lint` (as a Dart analyzer plugin, not
custom_lint, which is broken in the IDE on Dart 3.13).

## 008. Forms: flutter_form_builder (2026-09-27)
Already migrated to `material_ui`; reactive_forms has not been released in
9 months and is not migrated.

## 009. Lints: very_good_analysis + Dart 3.13 lints (2026-09-27)
CI runs `dart analyze` because `flutter analyze` hides analyzer plugin
diagnostics (flutter/flutter#193203).
`public_member_api_docs` is off for now: on Dart 3.13.4 it reports every
primary constructor as undocumented. Public APIs are still documented by
convention; re-enable the rule once the linter understands primary
constructors.

## 010. Single package layout (2026-09-27)
`lib/app` (wiring), `lib/core` (cross-cutting), `lib/features/<name>` with a
public barrel and private `src/`. Boundaries enforced by lint rules and tests,
not by separate packages. Simpler to clone and rename than a pub workspace.
