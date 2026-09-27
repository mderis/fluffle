# Flutter / Dart Baseline for the New Template

Researched 2026-09-27 from docs.flutter.dev, dart.dev, flutter.dev/blog, pub.dev and flutter/flutter issues.
Companion to `fluffle-feature-inventory.md`. Items marked **(?)** could not be fully verified and should be tested before we rely on them.

---

## 1. Target versions

| Thing | Baseline | Fluffle today |
|---|---|---|
| Flutter | **3.47** (stable, 2026-08-12) | ~3.41/3.44 era |
| Dart | **3.13** (`sdk: ^3.13.0`) | `^3.11.0` |
| iOS min | **15** (Xcode 27 ready) | 13 |
| iOS integration | **Swift Package Manager** (default since 3.44), **UIScene** lifecycle (required with Xcode 27) | UIScene already present, CocoaPods |
| Android | compileSdk/targetSdk **36**, minSdk **24**, **AGP 9.1** with built-in Kotlin, KGP 2.4, Gradle 9.3.1, **Java 17** | no android folder |
| Material | **`material_ui` 1.4.0** + `cupertino_ui` 1.1.1 (standalone) | `flutter/material.dart` |

```yaml
environment:
  sdk: ^3.13.0
  flutter: ">=3.47.0"   # pub now enforces the Flutter upper bound too, keep it deliberate
```

Note: the old in-SDK Material/Cupertino libraries are frozen (since 3.44) and slated for formal deprecation, reportedly in the November 2026 stable (3.50). `flutter create` on master already generates `material_ui` projects.

---

## 2. Material and Cupertino as standalone packages

```yaml
dependencies:
  flutter: {sdk: flutter}
  flutter_localizations: {sdk: flutter}   # still needed: gen-l10n output imports it (?)
  material_ui: ^1.4.0
  cupertino_ui: ^1.1.1                    # only if we import it directly
  intl: ^0.20.2
```
```dart
import 'package:material_ui/material_ui.dart';     // was flutter/material.dart
import 'package:cupertino_ui/cupertino_ui.dart';   // was flutter/cupertino.dart
```
Migration of existing code: `dart fix --apply --code=migrate_design_widgets`.

### 2.1 Localization gotcha (verified, issue flutter/flutter#191072, still open)
`flutter gen-l10n` still emits `flutter_localizations` imports and a hardcoded delegate list. Using `L10n.localizationsDelegates` with `material_ui` crashes with *"No MaterialLocalizations found"*. **Always list delegates manually:**
```dart
MaterialApp.router(
  localizationsDelegates: [L10n.delegate, ...GlobalMaterialLocalizations.delegates],
  supportedLocales: L10n.supportedLocales,
  builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
  ...
)
```
`GlobalMaterialLocalizations.delegates` (from `material_ui`) already includes Cupertino + Widgets delegates. Avoid importing `flutter_localizations` directly in files that import `material_ui` (name clashes) (?).

### 2.2 Compatibility bridge
`MaterialUiCompatibilityBridge` (and `CupertinoUiCompatibilityBridge`) in `MaterialApp.builder` lets not-yet-migrated packages still resolve `Theme.of` / `MaterialLocalizations.of`. It can **not** fix type mismatches: a package whose public API takes SDK Material types (`ColorScheme`, `TextTheme`, ...) can't receive `material_ui` types. Check each UI-facing dependency.

---

## 3. Dart language features to adopt

| Feature | Since | Use in template |
|---|---|---|
| **Null-aware elements** `[?header]`, `{'cursor': ?cursor}` | 3.8 | Dio query maps and headers, optional widget children |
| **Dot shorthands** `.center`, `.all(16)`, `.circular(12)`, `.running` | 3.10 | All widget code, enums, switches. Not on the left of `==`, needs a context type |
| **Private named parameters** `Foo({required this._repo})` (callers write `repo:`) | 3.12 | Injected dependencies in services and notifiers |
| **Primary constructors** `class const Money(final int cents, final String currency);` | 3.13 stable | Entities, value objects, failures, config, enhanced enums (`enum Flavor(final String apiUrl) {...}`) |
| **Extension types** `extension type UserId(String value);` | 3.3 | Typed IDs (zero cost) |
| **Sealed classes + patterns** | 3.0 | `Result`, `Failure`, UI state |

Primary constructor rules: `final`/`var` on a parameter declares a field; a const one can't have a body (validate with `this : assert(...)`); no other non-redirecting generative constructors; body can't be `async` or `=>`.

**Breaking in 3.13:** `final`/`var` on a non-declaring parameter is now a compile error. Old generated code (Freezed < 4) and code written with `prefer_final_parameters` break; `dart fix` handles it.

**Formatter at language 3.13:** splits imports into blank-line sections, block-formats parameter lists, new method-chain heuristics. Expect one big formatting commit. Consider `formatter: trailing_commas: preserve` to keep Flutter widget trees split.

---

## 4. Tooling

- **Analyzer plugins (Dart 3.10+)** replace `custom_lint`, which is effectively broken in the IDE on Dart 3.13. Configure under top-level `plugins:`:
  ```yaml
  plugins:
    riverpod_lint: ^3.1.9
    arch_rules:
      path: tool/arch_rules      # our own architecture rules (feature boundaries, core must not import features)
  ```
  Gotcha: `flutter analyze` currently hides plugin diagnostics (flutter/flutter#193203). **Use `dart analyze` in CI.**
- **Lints to enable:** the six primary-constructor lints (`use_declaring_parameters`, `unnecessary_type_name_in_constructor`, `empty_container_bodies`, `initialize_in_field_declaration`, `unnecessary_primary_constructor_body`, `unnecessary_const_in_enum_constructor`), `use_null_aware_elements`, `unnecessary_ignore`, `no_dynamic_casts`, `no_raw_types`, `switch_on_type`, `remove_deprecations_in_breaking_versions`. Drop `prefer_final_parameters` (deprecated).
- **build_runner 2.16:** AOT-compiled builders, 1.4x to 4x faster builds, overwrites stale outputs by default (`--delete-conflicting-outputs` no longer needed), `--only-check` for CI.
- **Widget Previews (stable in 3.47):** `@Preview(...)`, `MultiPreview`, `PreviewThemeData` for theme layering. Runs on web (no plugins, no `dart:io`). Add `.widget_preview/` to `.gitignore`. Great fit for a widget catalog and for the docs site.
- **Dart & Flutter MCP server** (`dart mcp-server`), stable, with agentic hot reload (3.44).
- **Pub workspaces** with globs (`workspace: [packages/*]`, 3.11) if we split the template into packages.
- **Doc comments (dartdoc 9):** `{@example /example/x.dart#region}` pulls snippets from example files, `<callout-box>`, `@docImport`. Useful for API docs that feed the documentation website.
- **DevTools 2.60**, stateful web hot reload is default.

---

## 5. Platform setup

**iOS**
- Min 15, SwiftPM default (CocoaPods registry goes read-only 2026-12-02).
- UIScene: plugins registered in `didInitializeImplicitFlutterEngine` (`FlutterImplicitEngineDelegate`), `UIApplicationSceneManifest` in Info.plist. Fluffle's Runner already follows this.

**Android**
- AGP 9 built-in Kotlin: no `kotlin-android` plugin, `kotlin { compilerOptions { jvmTarget = JvmTarget.JVM_17 } }`, `android.builtInKotlin=true`.
- **Edge-to-edge is mandatory** (opt-out crashes on Android 16+): always rely on `SafeArea` / `MediaQuery.padding`.
- **Predictive back** is the default transition: keep `android:enableOnBackInvokedCallback="true"`, use `PopScope(onPopInvokedWithResult:)` (this is also how the unsaved-changes guard should work).
- On Android 17 large screens (600dp+), orientation locks are ignored.

**Flavors (official)**
- Android `productFlavors`, iOS schemes + `Debug-<flavor>` / `Release-<flavor>` build configs, per-flavor bundle id, display name, icon.
- Read the flavor in Dart via `appFlavor` (`package:flutter/services.dart`).
- pubspec: per-flavor assets (`assets: - path: x flavors: [dev]`) and `flutter: default-flavor: prod`.
- This replaces fluffle's Dart-only `main_dev.dart` / `main_prod.dart` approach (entrypoints can stay, but native flavors become real).

---

## 6. Framework APIs: use these, avoid those

**Use:** `RadioGroup`, `DropdownMenuFormField`, `CarouselView.builder` (infinite scroll), `PopScope`, `Navigator.popUntilWithResult`, `SensitiveContent` (Android 35+), `SliverSemantics`, `headingLevel`, `MediaQueryData.highContrast` / `displayCornerRadii`, `WidgetState*`, `RepeatingAnimationBuilder`, test matchers `isSemantics` / `accessibilityAnnouncement`.

**Avoid (deprecated or removed 3.35 to 3.47):** `Radio.groupValue/onChanged`, `DropdownButtonFormField.value` (use `initialValue`), `AppBarTheme.color`, `MaterialState*`, `WillPopScope`, `Semantics.header` (no-op now), `containsSemantics`, `findChildIndexCallback`, `ReorderableListView.onReorder`, `cacheExtent` (use `scrollCacheExtent`), `describeEnum` (removed), `Form` as a direct sliver.

**Behavior changes:** SnackBar with an action no longer auto-dismisses (3.38; our `AppSnackBar` must set `persist: false` or handle it (?)); `ListTile` inside a colored `Container` raises a debug error (3.44).

**M3 Expressive:** `material_ui` has a `StyleVariant` enum, but Expressive components are not landed yet. Don't design around them yet (?).

---

## 7. Packages: keep, upgrade, replace

| Package | Version | Decision |
|---|---|---|
| flutter_riverpod | 3.4.x | Keep. Mutations + offline persistence are still `experimental` imports: wrap if used |
| riverpod_generator / riverpod_lint | 4.0.x / 3.1.9 | **Adopt** (lint via analyzer plugin) |
| go_router | **18.0.x** | Upgrade (already on `material_ui`). 17+ notifies observers for shell navigation |
| go_router_builder | 4.5.x | Consider for typed routes, verify with go_router 18 (?) |
| dio / retrofit / retrofit_generator | 5.11 / 4.10 / 10.2 | Keep |
| dio_cache_interceptor | 4.0.x | Keep and actually wire it |
| freezed | **4.0.2+** | Upgrade (primary constructor support; 4.0.0 is breaking) |
| json_serializable | 6.14.x | Keep; primary constructor compat only third-party tested (?) |
| fpdart | 1.2.0 (v2 stalled) | **Replace** with our own sealed `Result<T>` (matches the official architecture guide) |
| flutter_secure_storage | **11.x** | Upgrade carefully (old Android ciphers removed; new template starts fresh so fine) |
| shared_preferences | 2.5.x | Keep, use `SharedPreferencesAsync` / `WithCache` only |
| envied | 1.3.x | Keep (obfuscation is not security) |
| posthog_flutter / sentry_flutter + sentry_dio | 5.44 / 9.30 | Keep |
| logger | 2.8 | Keep |
| reactive_forms vs flutter_form_builder | 18.2.2 (stale 9 months) vs **11.0** (on material_ui) | **Pick one**: flutter_form_builder is better aligned now |
| cached_network_image | **4.0.0** | Upgrade (on material_ui) |
| shimmer | 4.0 | **Replace with skeletonizer 3.x** |
| flutter_svg | 2.3 | Keep; precompile static SVGs with vector_graphics_compiler |
| image_picker / image_cropper | 1.2.3 / 12.2 | Keep |
| connectivity_plus / url_launcher / intl / mocktail | current | Keep |
| custom_lint | 0.8.1 | **Remove** |
| flutter_lints vs very_good_analysis | 6.0 / 11.0 | Pick one (VGA 11 needs Dart 3.13) |
| flutter_native_splash / flutter_launcher_icons | 2.4.8 / 0.14.4 | Adopt |

Before committing the stack: pin versions, run build_runner, then `dart analyze`, to prove every generator emits valid Dart 3.13 code.

---

## 8. Architecture alignment (official Flutter guide)

The official guide (docs.flutter.dev/app-architecture) recommends: MVVM in the UI layer (views + 1:1 view models), repositories as single source of truth, stateless services per data source, optional domain use cases only when logic spans repositories, immutable models, DI, abstract repositories, go_router, fakes over mocks in tests, a sealed `Result<T>` (`Ok` / `Error`), and a **Command** pattern for UI actions (running / error / result, blocks re-entry).

Mapping to our Riverpod stack:
- View model = `Notifier` / `AsyncNotifier` (fluffle's "Controller" naming fits).
- Command = Riverpod mutations (experimental) or a small `Command` wrapper with `AsyncValue`.
- `Result<T>` replaces fpdart `Either`.
- Services = Retrofit APIs; repositories keep the `Result` boundary.

---

## 9. What this changes in the fluffle port (quick list)

1. `material_ui` imports, manual l10n delegates, compatibility bridge in `builder`.
2. Dart 3.13 syntax: primary constructors for `User`, `Failure`s, `AppConfig`, `Paginated`; dot shorthands everywhere; null-aware elements in API maps.
3. Freezed 4 for DTOs; drop fpdart for a sealed `Result`.
4. Analyzer plugins: `riverpod_lint` + our own `arch_rules` plugin replacing the regex boundary test (keep the test as a fallback). CI uses `dart analyze`.
5. Native flavors (iOS schemes + Android productFlavors) + `appFlavor`; iOS 15, SwiftPM, AGP 9.
6. Edge-to-edge and predictive back aware UI; unsaved-changes guard via `PopScope`.
7. Skeletonizer, flutter_form_builder (or keep reactive_forms, decide once), cached_network_image 4, go_router 18.
8. Widget Previews for every shared widget (feeds the docs site).
9. dartdoc `{@example}` snippets for public APIs (feeds the docs site).

---

## Sources
- https://docs.flutter.dev/release/release-notes
- https://flutter.dev/blog/whats-new-in-flutter-3-47 · https://flutter.dev/blog/whats-new-in-flutter-3-44
- https://flutter.dev/blog/decoupling-material-cupertino
- https://docs.flutter.dev/release/breaking-changes/material-ui-and-cupertino-ui
- https://github.com/flutter/flutter/issues/191072 (gen-l10n + material_ui)
- https://github.com/flutter/flutter/issues/193203 (flutter analyze hides plugin diagnostics)
- https://pub.dev/packages/material_ui · https://pub.dev/packages/freezed/changelog · https://pub.dev/packages/go_router/changelog · https://pub.dev/packages/riverpod_lint/changelog · https://pub.dev/packages/build_runner/changelog
- https://dart.dev/blog/announcing-dart-3-13 · https://dart.dev/resources/whats-new · https://dart.dev/language/primary-constructors · https://dart.dev/language/dot-shorthands · https://dart.dev/tools/analyzer-plugins
- https://docs.flutter.dev/deployment/flavors · https://docs.flutter.dev/release/breaking-changes/uiscenedelegate · https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers · https://docs.flutter.dev/platform-integration/android/predictive-back · https://docs.flutter.dev/release/breaking-changes/default-systemuimode-edge-to-edge
- https://docs.flutter.dev/tools/widget-previewer
- https://docs.flutter.dev/app-architecture/guide · https://docs.flutter.dev/app-architecture/design-patterns/result · https://docs.flutter.dev/app-architecture/design-patterns/command
