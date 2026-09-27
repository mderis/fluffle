# Fluffle (app_template) Feature Inventory

Source: `/Users/moslem/projects/flutter/fluffle`, inspected read-only on 2026-09-27.
Scope: all of `lib/` (~6.8k lines incl. generated), `test/`, `.github/`, `Makefile`, `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`, env files (keys only), `ios/`.

> **State of the repo:** the working tree has a large **uncommitted refactor** (auth moved into `features/auth/src/`, `core/session/` added, providers renamed to `*_notifier.dart`, `test/architecture/` untracked, `auth.dart` barrel untracked). `ios/` and `pubspec.lock` are untracked. There is **no `android/` folder** (CI generates platforms with `flutter create .`). This inventory describes the working tree, not the last commit.

Legend: ✅ implemented and wired · 🟡 implemented but unused / partial · ⛔ declared only (dependency or stub, no real code)

---

## 1. Tech stack

| Concern | Package | Status |
|---|---|---|
| State | `flutter_riverpod` 3.2 (`Notifier`, `AsyncNotifier`, `Provider`, `FutureProvider`, no codegen) | ✅ |
| Routing | `go_router` 17 (`StatefulShellRoute.indexedStack`, redirect, `refreshListenable`) | ✅ |
| HTTP | `dio` 5.9 + `retrofit` 4.9 | ✅ |
| Monitoring for HTTP | `sentry_dio` (`dio.addSentry()`) | ✅ |
| Models | `freezed` 3 + `json_serializable` | ✅ (DTOs only) |
| Functional errors | `fpdart` `Either<Failure, T>` | ✅ |
| Secure tokens | `flutter_secure_storage` 10 | ✅ |
| Prefs | `shared_preferences` | ✅ |
| Env / secrets | `envied` (+ obfuscation) | ✅ |
| Forms | `reactive_forms` 18 | ✅ (login/signup) |
| Forms (2nd lib) | `flutter_form_builder` | ⛔ unused |
| L10n | `flutter gen-l10n` (`L10n` class, en + fa) | ✅ |
| Analytics | `posthog_flutter` 5 | ✅ |
| Errors / perf | `sentry_flutter` 9 | ✅ |
| Logging | `logger` | ✅ (HTTP logging in non-prod) |
| HTTP cache | `dio_cache_interceptor` | ⛔ in pubspec, **not wired** (README says it is) |
| Connectivity | `connectivity_plus` | ⛔ unused |
| Images | `cached_network_image`, `flutter_svg` | ⛔ unused |
| Image pick/crop | `image_picker`, `image_cropper` | ⛔ unused (only a UI sheet exists, no picker call) |
| Loading skeleton | `shimmer` | ⛔ only color/duration tokens exist |
| Links | `url_launcher` | ⛔ unused |
| Testing | `mocktail`, `network_image_mock`, `integration_test` | ⛔ unused (no integration_test dir) |

SDK: Dart `^3.11.0`. Version `0.1.0+1`. iOS deployment target 13.0, bundle id `com.moslem.fluffle`.

---

## 2. Architecture and conventions

### 2.1 Folder layout
- `lib/core/` cross-cutting infrastructure: analytics, api, config, domain, init, l10n, monitoring, presentation, router, session, storage, theme, utils, validators, widgets.
- `lib/features/<name>/` feature modules: `auth`, `home`, `onboarding`, `profile`, `shell`.

### 2.2 Feature module pattern (only `auth` follows it fully)
```
features/auth/
├── auth.dart          # public barrel: exports authControllerProvider, LoginScreen, SignupScreen
└── src/               # private
    ├── application/   # AuthController + provider wiring (authApiProvider, authRepositoryProvider)
    ├── data/          # Retrofit AuthApi, AuthRepositoryImpl, DTOs (freezed)
    ├── domain/        # AuthRepository interface, AuthTokens entity
    └── presentation/  # grouped per screen: login/, signup/
```
- Barrel documents *why* API, repository and DTOs are not exported.
- UseCase layer was deliberately removed (last commit `refactor: remove UseCase abstractions`).

### 2.3 Architecture test ✅
`test/architecture/feature_boundary_test.dart` scans `lib/` with a regex and fails if any file outside `features/<x>/` imports `package:app_template/features/<x>/src/...`. Runs in CI via `flutter test`.

### 2.4 Shared state rule
State that several features need lives in `core/` (current user, theme, locale). "Owning feature writes, others read." Canonical example: `core/session/current_user_notifier.dart`.

### 2.5 Provider naming convention (documented in README + barrel)
| Name | Backing class | Usage |
|---|---|---|
| `xxxNotifierProvider` | `Notifier<T>` holding state | `ref.watch` |
| `xxxControllerProvider` | `AsyncNotifier<void>` orchestrating ops | `ref.read(...notifier).method()` |
| `xxxSignalProvider` | `Notifier<Event>` one-shot event | `ref.listen` |
| `xxxRepositoryProvider` / `xxxApiProvider` | service | `ref.read(...).method()` |
| bare `xxxProvider` | `Provider` / `FutureProvider` | `ref.watch` |

### 2.6 UI conventions (README)
No hardcoded text (always `L10n.of(context)`), no hardcoded sizes (tokens), colors via `context.colors.X`, `EdgeInsetsDirectional` / `PositionedDirectional` for RTL, haptic feedback on taps.

### 2.7 Lint rules (`analysis_options.yaml`) ✅
`flutter_lints` + `always_use_package_imports`, `prefer_single_quotes`, `require_trailing_commas`, `prefer_const_*`, `prefer_final_locals`, `sort_child_properties_last`, `use_key_in_widget_constructors`, `avoid_unnecessary_containers`, `sized_box_for_whitespace`, `avoid_print`, `use_build_context_synchronously`, `cancel_subscriptions`, `close_sinks`. Excludes `*.g.dart`, `*.freezed.dart`, `lib/l10n/**`. `invalid_annotation_target` ignored (for freezed + JsonKey).

---

## 3. Bootstrap, flavors and config

### 3.1 Entry points ✅
- `main_dev.dart` → `bootstrap(AppConfig.dev())`
- `main_prod.dart` → `bootstrap(AppConfig.prod())`
- `main.dart#bootstrap(config)`:
  1. `SentryWidgetsFlutterBinding.ensureInitialized()`
  2. `SharedPreferences.getInstance()` (awaited once, injected synchronously later)
  3. PostHog setup: api key, host, `captureApplicationLifecycleEvents = true`, `debug = !isProd`
  4. `SentryFlutter.init`: DSN, `environment = flavor.name`, `tracesSampleRate` 1.0 dev / 0.3 prod, `enableAutoPerformanceTracing`, `enableUserInteractionTracing`
  5. `runApp(ProviderScope(overrides: [appConfigProvider, sharedPreferencesProvider], child: App()))` inside Sentry `appRunner`

### 3.2 Flavors ✅ (Dart-only)
- `enum Flavor { dev, prod }`, `AppConfig` with `isDev` / `isProd`.
- `appConfigProvider` and `sharedPreferencesProvider` throw `UnimplementedError` unless overridden in bootstrap (fail-fast DI pattern).

### 3.3 Env with envied ✅
- `.env.dev`, `.env.prod` (gitignored), `.env.example` committed.
- Keys: `API_BASE_URL`, `AUTH_CLIENT_ID`*, `AUTH_CLIENT_SECRET`*, `POSTHOG_API_KEY`*, `POSTHOG_HOST`, `SENTRY_DSN` (* = `obfuscate: true`).
- Separate `EnvDev` / `EnvProd` classes; `make regen-env` cleans build_runner cache to pick up changes.

### 3.4 App widget (`app.dart`) ✅
`MaterialApp.router` with light/dark theme, persisted `themeMode` (fallback system), persisted `locale`, `SupportedLocales.all`, `L10n` + Global Material/Widgets/Cupertino delegates, `debugShowCheckedModeBanner: false`.

---

## 4. App initialization and splash ✅
- `appInitProvider` (`FutureProvider<void>`) runs in parallel: locale load, theme load, auth session restore (`authControllerProvider.future`). Comment reserves slots for settings, feature flags, remote config.
- Splash screen: bolt icon + localized app title + spinner. Shown while `appInitProvider` is loading (router redirect).

---

## 5. Routing (`core/router/`) ✅
- `AppRoutes` constants: `/splash`, `/login`, `/signup`, `/onboarding/language`, `/onboarding/theme`, `/home`, `/profile`, `/profile/edit`, `/settings`.
- `RouterNotifier` (ChangeNotifier bridge) listens to `appInitProvider`, `localeNotifierProvider`, `themeModeNotifierProvider` and only notifies when "chosen / not chosen" flips, so the `GoRouter` is created once and redirects re-evaluate without rebuilding it.
- Redirect chain: not ready → `/splash`; no locale → language picker; no theme → theme picker; ready and on splash/onboarding → `/home`; otherwise pass through.
- **Auth is intentionally not a routing concern**: protected screens are wrapped in `AuthGate` instead of redirecting.
- `StatefulShellRoute.indexedStack` with 2 branches, each with its own `navigatorKey` (state preserved per tab). Tab roots use `NoTransitionPage`.
  - Branch 0: `/home`
  - Branch 1: `/profile` → `AuthGate(authenticated: ProfileScreen, unauthenticated: LoginScreen)`, child route `edit`.
- Full-screen routes outside shell: login, signup, onboarding, settings (placeholder widget).
- **Automatic analytics screen tracking**: listens to both `routeInformationProvider` and `routerDelegate` (captures tab switches and in-branch pops), de-duplicates by last path, maps paths to friendly names (`'/onboarding/language' → 'Onboarding · Language'`), falls back to raw path.
- `unsavedChangesNotifierProvider` (bool dirty flag) used by the shell to guard tab switches.

---

## 6. Onboarding ✅
1. **Language picker**: list of cards (flag emoji + native name: English, فارسی), tile text direction follows the language, haptic `selectionClick`, persists `locale` in SharedPreferences.
2. **Theme picker**: System / Light / Dark cards with icons, haptic, persists `theme_mode`.
3. Router automatically moves forward once each choice is stored; next launches skip onboarding.
- Side effects on choice: PostHog super property `language` / `theme_mode`; Sentry tag `language`.

---

## 7. Authentication (`features/auth`) ✅ skeleton, 🟡 partial
### 7.1 API (Retrofit, Laravel Passport / Apiato-shaped)
| Method | Endpoint | Used by UI |
|---|---|---|
| POST | `/v1/oauth/token` (password grant) | ✅ login |
| POST | `/v1/register` | ✅ signup |
| DELETE | `/v1/logout` | ✅ profile logout |
| GET | `/v1/user/profile` | ✅ session restore |
| PUT | `/v1/user` | 🟡 controller method exists, no UI |
| POST | `/v1/forgotpassword` | 🟡 repository only, button disabled |
| POST | `/v1/resetpassword` | 🟡 repository only |

### 7.2 Repository (`AuthRepositoryImpl`)
- Every method returns `Either<Failure, T>`; catches `DioException` and unwraps the `Failure` placed by `ErrorInterceptor`.
- Login body: `grant_type=password`, `client_id`, `client_secret`, `username`, `password`.
- Register sends `password_confirmation` + client credentials.
- Stores `access_token` / `refresh_token` in secure storage; clears them on logout even if the API call fails.
- DTOs: `AuthResponseDto` (access, refresh, expires_in, token_type) → `AuthTokens`; `UserDto` / `UserResponseDto` (`{data: {...}}`) → core `User` entity (`id`, `email`, `name`, `username`, `avatarUrl`, `emailVerifiedAt`, `displayName` getter).

### 7.3 Controller (`AuthController extends AsyncNotifier<void>`)
- `build()`: restores session by calling `getCurrentUser`, writes result into `currentUserNotifierProvider`.
- `login`, `register`: set loading, return `Failure?` to the caller (UI decides how to show it), then load the user.
- `updateUser`, `logout`.
- `_setUser` side effects: PostHog `identify` (email, name) or `reset`; Sentry `setUser` or `clearUser`.

### 7.4 Screens
- **Login**: reactive form (email: required+email, password: required+min 8), inline error text, loading spinner in button, disabled "Forgot password?" link, "Sign up" button, success snackbar with haptic, navigates to home.
- **Signup**: name, email, password, confirm (`Validators.mustMatch`), inline error, spinner, link back to login.

### 7.5 AuthGate widget ✅
Swaps between `authenticated` / `unauthenticated` children by watching `currentUserNotifierProvider`; reacts live to login/logout.

---

## 8. Session (`core/session`) ✅
- `currentUserNotifierProvider` (`User?`), single source of truth, only auth writes via `set()`.
- `isAuthenticatedProvider` (bool) 🟡 unused.

---

## 9. Networking (`core/api`) ✅
- `dioProvider`: base URL from config, 15 s connect/receive/send timeouts, JSON headers.
- Interceptor chain (order documented): `AuthInterceptor` → `RefreshInterceptor` → `LoggingInterceptor` (non-prod only) → `ErrorInterceptor`, then `dio.addSentry()` last.
  - **AuthInterceptor**: reads access token from secure storage, adds `Authorization: Bearer`.
  - **RefreshInterceptor** (`QueuedInterceptor`): on 401 with a stored refresh token, calls refresh with a separate Dio, stores new tokens, retries the original request; on failure clears tokens.
  - **LoggingInterceptor**: `→ METHOD uri`, `← status`, `✗ error` via `logger` PrettyPrinter.
  - **ErrorInterceptor**: maps `DioException` to domain `Failure` and puts it in `error` (timeouts / connection / cancel / bad cert → `NetworkFailure`; 401/403 → `AuthFailure`; 422 → `ValidationFailure` with Laravel `errors` map parsed to `Map<String, List<String>>`; other 4xx/5xx → `ServerFailure(statusCode)`; server `message` field preferred).
- Providers: `secureStorageProvider`, `loggerProvider`.
- Response envelopes (Apiato / Fractal format) 🟡: `ApiListResponse<T>` (`data` + `meta`), `ApiSingleResponse<T>`, `ApiMeta` (nullable `pagination`, with a comment explaining why), `ApiPagination` (`total`, `count`, `per_page`, `current_page`, `total_pages`) using `genericArgumentFactories`.

---

## 10. Domain error model ✅
`sealed class Failure {message, code}` with `NetworkFailure`, `ServerFailure(statusCode)`, `AuthFailure`, `ValidationFailure(fieldErrors)`, `CacheFailure` (unused). Exhaustive `switch` possible.

---

## 11. Pagination base (`core/presentation/paginated_state.dart`) 🟡 unused
- `Paginated<T>` entity (`items`, `total`, `currentPage`, `totalPages`, `hasMore`) + `ApiPagination.toPaginated()` mapper.
- `PaginatedState<T>` (items, page, totalPages, isLoadingMore, search, failure) with nullable-safe `copyWith` (function wrappers for clearing).
- `PaginatedAsyncNotifier<T>`: subclass only implements `fetchPage(page, search)`; gets `build` (page 1), `loadMore` (guarded), `search(query)` (trim, null for empty), `refresh()` (keeps current search), page-level error handling (first page error vs. load-more error).

---

## 12. Localization and RTL ✅
- `l10n.yaml`: ARB dir `lib/l10n`, template `app_en.arb`, class `L10n`, non-nullable getter.
- Locales: `en`, `fa`; 42 keys each, **no missing keys** in fa. Includes ICU placeholders (`charCounter`, `validationMinLength`, `validationMaxLength`).
- `SupportedLocales` with `rtlLocales` set and `isRtl()`.
- `LocaleNotifier` (`AsyncNotifier<Locale?>`): null = not chosen yet (drives onboarding), persists language code.
- Directional paddings used in onboarding and auth screens.

---

## 13. Design system / theme (`core/theme`) ✅
- **`AppColors`** abstract token set (~45 tokens: primary trio, background, surface, text x7, semantic + bg variants, snackbar x7, scrim, overlay, divider, shadow, shimmer, badge, nav x4, input x2, button, sheet x2) with `LightAppColors` / `DarkAppColors`.
- **`AppColorsExtension`** (`ThemeExtension`) + `context.colors` extension.
- **`AppTheme.light()/dark()`**: Material 3, custom `ColorScheme`, AppBar (flat, no scroll elevation, status bar style per brightness), NavigationBar (indicator tint, selected label/icon states), Card, InputDecoration (filled, outline, focused border), ElevatedButton (full width), TextButton, Divider, full `TextTheme` mapped to tokens.
- **Spacing** `AppSpacing` (4 px grid xxs to hero, `EdgeInsets` presets, `screenPadding`, `listBottomPadding`).
- **Radius** `AppRadius` (+ `BorderRadius` getters, top/bottom variants).
- **Sizes** `AppSizes` (icons, avatars, buttons, inputs, nav, divider, dialog width).
- **Typography** `AppFontSize` (iOS-like scale caption to display), `AppLineHeight`, `AppLetterSpacing`, `AppFontWeight`.
- **Effects** `AppOpacity` (glass, decor, state, overlay), `AppBlur`, `AppShadow` (sm/md/lg/elevated, tintable), `AppStroke`.
- **Motion** `AppDuration` (incl. per-type snackbar durations), `AppCurve`.
- **Styles** `AppButtonStyle` (tinted, destructive, pill, secondary, solidDestructive), `AppBoxStyle` (icon containers).
- `AppLayout` empty placeholder for screen-specific constants.
- `ThemeModeNotifier` (`AsyncNotifier<ThemeMode?>`), null = not chosen yet.

---

## 14. Shared widgets and utilities (`core/widgets`, `core/utils`, `core/validators`)
| Item | What it does | Used |
|---|---|---|
| `AppSnackBar` | success / info / warning / error variants, icon + message + optional action, floating, per-variant duration, optional haptic, clears previous | ✅ |
| `AppConfirmDialog.show()` | glass-style dialog with icon circle, title, body, cancel/confirm, fade+scale transition, optional warning haptic, returns `bool` | ✅ (shell) |
| `AppImagePickerSheet.show()` | bottom sheet: Take photo / Choose from library / Remove (optional), returns `ImagePickerResult` enum, haptics | 🟡 |
| `AppReadOnlyField` | label + input-styled read-only value, tap to copy | 🟡 |
| `AppCharCounter` | `current / max` with normal / warning (80%) / over colors | 🟡 |
| `PullToRefreshHaptic` | `RefreshIndicator` with "ratchet" haptic ticks every N px and a firmer impact at trigger distance | ✅ (home) |
| `AuthGate` | see 7.5 | ✅ |
| `AppClipboard.copy()` | copy + localized snackbar + analytics event `text_copied {label}` | 🟡 |
| `AppValidators` | l10n-aware `FormFieldValidator`s: `compose`, `required`, `minLength`, `maxLength`, `startsWithLetter`, `endsWithLetterOrNumber`, `usernameChars` | 🟡 |

---

## 15. Main shell UX (`features/shell`) ✅
- Material 3 `NavigationBar` with Home / Profile (outlined vs filled icons), localized labels.
- Haptic on every tab tap.
- **Re-tap active tab → scroll to top**: `scrollToTopSignalProvider` emits `ScrollToTopEvent(branch, counter)`; Home listens via `ref.listenManual` and animates to 0.
- **Unsaved-changes guard** on tab switch: if dirty, shows `AppConfirmDialog`, clears flag on discard.

---

## 16. Analytics (`core/analytics`) ✅
- `AnalyticsService` interface: `identify`, `track`, `screen`, `setUserProperties`, `registerSuperProperty`, `unregisterSuperProperty`, `reset`.
- `PostHogAnalyticsService` implementation (injectable `Posthog` for tests), `analyticsProvider`.
- Wired events: automatic screen views (router), identify/reset on auth, super properties `language` and `theme_mode`, `text_copied`, app lifecycle events (PostHog config).

## 17. Monitoring (`core/monitoring`) ✅
- `ErrorReporter` interface: `captureException(extras)`, `setUser`, `clearUser`, `setTag`.
- `SentryErrorReporter` (extras written as Sentry contexts), `errorReporterProvider`.
- Sentry: environment per flavor, performance tracing, Dio integration, user set on login, `language` tag.

---

## 18. Stub feature screens
- **Home**: app bar, intro text, list of 8 demo cards describing the stack, pull-to-refresh (fake 600 ms), scroll-to-top.
- **Profile** (behind AuthGate): initial-letter avatar, name, email, Settings row, Logout row, edit icon → `/profile/edit`.
- **Edit profile**: placeholder text.
- **Settings**: `_Placeholder` widget inside the router file.

---

## 19. Tooling and repo automation
### 19.1 Makefile ✅
`run-dev`, `run-prod`, `build-apk-prod`, `build-appbundle-prod`, `build-ipa-prod`, `codegen`, `codegen-watch`, `regen-env`, `l10n`, `clean`, `rebuild` (clean → pub get → codegen → l10n).

### 19.2 GitHub Actions ✅
- **CI** (`ci.yml`, push/PR to main, concurrency cancel):
  - `Auto-format` (PR only): runs `dart format` on non-generated files; same-repo PR → bot commits `ci: dart format` and pushes; fork PR → fails with instructions.
  - `Analyze & Test` (after format): copies `.env.example` to dev/prod, `flutter create .`, pub get, build_runner, gen-l10n, `flutter analyze`, `flutter test`.
- **Dependabot auto-merge**: approves + enables squash auto-merge for semver patch/minor.
- **Dependabot**: weekly Monday for `pub` (minor+patch grouped, prefix `deps`) and `github-actions` (prefix `ci`), labels.
- `FUNDING.yml`, MIT `LICENSE`, `CONTRIBUTING.md`.

### 19.3 Docs ✅
README covers stack table, architecture, feature layout, rename steps, env setup, GitHub branch protection + merge settings table, onboarding flow, auth, conventions, provider naming, feature isolation, how to remove auth / PostHog / Sentry.

### 19.4 Tests 🟡
Only `widget_test.dart` (a `1 + 1 == 2` smoke test) and the architecture boundary test.

### 19.5 Platform (iOS only) 🟡
Generated Runner with `SceneDelegate` / `FlutterImplicitEngineDelegate` (new Flutter scene lifecycle), no custom plist keys. No Android project.

---

# Improvement notes

Ordered by impact. "BUG" = likely broken behavior today.

## A. Bugs and correctness

1. **BUG: refresh endpoint does not match login flow.** `RefreshInterceptor` posts `{'refresh_token'}` to `/auth/refresh`, but login uses Passport `/v1/oauth/token`. With Passport / Apiato, refresh is `POST /v1/oauth/token` with `grant_type=refresh_token`, `refresh_token`, `client_id`, `client_secret`. As written, token refresh never succeeds against the same backend. Move refresh into the auth data layer (inject a `TokenRefresher`) instead of hardcoding it in core.
2. **BUG: refresh failure does not log the user out in the UI.** Tokens are deleted but `currentUserNotifierProvider` still holds the user, so the app looks signed in until restart. Add a `sessionExpired` callback / stream from the interceptor that the auth controller listens to.
3. **BUG risk: deadlock / loops in `RefreshInterceptor`.** The retry goes through `_dio.fetch` which passes the same `QueuedInterceptor`; if the retried request returns 401 its `onError` queues behind the current one. Mark retries with `options.extra['retried'] = true` and skip them, or retry with a Dio that excludes the refresh interceptor.
4. **Concurrent 401s refresh N times.** Queued requests each refresh again. Compare the token used by the failed request with the currently stored token; if it already changed, just retry.
5. **Session restore calls the network even with no token** and treats *any* failure (offline, timeout, 500) as "logged out" while keeping the tokens. Check for a stored token first; on `NetworkFailure` keep a cached user (persist the `User` JSON) instead of clearing.
6. **Error messages are not localized.** `Failure` defaults are English strings and screens show `failure.message` directly. Map `Failure` types to l10n keys in the presentation layer; show server messages only for 4xx business errors.
7. **`ValidationFailure.fieldErrors` are never shown on fields.** Push them into the reactive form controls (`control.setErrors({'server': msg})`).
8. **reactive_forms validation messages are not configured**, so fields show no text (or English defaults). Provide `ReactiveFormConfig(validationMessages: ...)` using `L10n`.
9. **Login from the Profile tab jumps to Home** (`context.go(AppRoutes.home)`), and Sign up from there leaves the shell. When shown inside `AuthGate`, do nothing on success (the gate swaps automatically).
10. **Profile → Settings uses `context.go`**, replacing the stack (no back to profile). Use `push`. Same for edit profile if you want a back gesture to be reliable.
11. **Unsaved-changes guard only protects tab switches.** System back, swipe-back and AppBar back are not guarded. Use `PopScope` + GoRouter `onExit`, and scope the dirty flag per route (a global bool easily stays dirty).
12. **Sentry user-interaction tracing is enabled but not wired**: requires wrapping the app in `SentryUserInteractionWidget`; and there is no `SentryNavigatorObserver` in `GoRouter(observers:)`, so no navigation breadcrumbs / screen transactions.
13. **PostHog manual setup**: verify that `com.posthog.posthog.AUTO_INIT = false` is set in iOS `Info.plist` (and Android manifest) as required by `posthog_flutter` when calling `Posthog().setup()` from Dart. It is not present now.
14. **iOS will crash when the image picker is used**: no `NSCameraUsageDescription` / `NSPhotoLibraryUsageDescription`. Also add `CFBundleLocalizations` (en, fa) so iOS system UI shows Persian.
15. **`routerProvider` never disposes the router or its listeners.** Add `ref.onDispose(router.dispose)` and remove listeners.
16. **Screen tracking uses raw paths** for unmapped routes, so dynamic routes (`/items/123`) explode cardinality. Use `GoRoute(name:)` and track by name.
17. **`PaginatedAsyncNotifier` race conditions**: fast search typing or refresh during loadMore can let stale responses overwrite newer ones. Add a request token / generation counter, debounce search, and cancel in-flight requests (`CancelToken`). Also a failed refresh wipes the visible list; keep old items and show the error.
18. **Theme colors don't animate**: `AppColorsExtension.lerp` returns `this`, so theme switches jump. Implement `lerp` with `Color.lerp` per token.
19. **`ColorScheme` is incomplete**: screens use `outlineVariant`, `onSurfaceVariant`, `primaryContainer` which are not mapped to tokens (they fall back to M3 defaults). Map every role you use, or use `context.colors` only.
20. **Glass effect is invisible**: `BackdropFilter` sits behind opaque `surface` / `sheetBg`, so blur costs GPU but shows nothing. Use a translucent color (`AppOpacity.glassBg*`) or drop the filter.
21. **`AppConfirmDialog` is always destructive** (red icon + red button). Add a `variant` (neutral / destructive).
22. **Logout has no confirmation or loading state** and uses `Colors.redAccent` (breaks the token convention).

## B. Security
23. **`AUTH_CLIENT_SECRET` ships inside the app.** envied obfuscation only slows extraction. Prefer a public Passport client (password grant without secret) / PKCE, or proxy token calls through your backend.
24. Centralize token keys: `access_token` / `refresh_token` strings are duplicated in 3 files. Create a `TokenStorage` class (read/write/clear, expiry) used by interceptors and repository.
25. Use `expiresIn` (currently ignored) for proactive refresh before expiry.
26. iOS Keychain survives uninstall: clear secure storage on first run after reinstall (SharedPreferences flag).
27. Set secure storage options explicitly (iOS `KeychainAccessibility.first_unlock` if you need background refresh).
28. Optional: certificate pinning, jailbreak/root detection for sensitive apps.

## C. Architecture
29. **`core` imports `features`** (`app_init_provider` → auth, `app_router` → every screen). Core should not depend on features; move the router and init into an `app/` layer (e.g. `lib/app/router.dart`, `lib/app/bootstrap.dart`).
30. **Only `auth` follows the `src/` + barrel pattern.** `home`, `profile`, `onboarding`, `shell` expose everything and `home` imports `shell`'s provider directly; the boundary test does not catch this. Give every feature a barrel + `src/`, and move `scrollToTopSignal` to `core` (it is shared).
31. Boundary test hardcodes the package name and only catches `package:` imports; read the name from `pubspec.yaml`. Consider `import_lint` / `custom_lint` rules, and a second rule: `core/` must not import `features/`.
32. Pick **one** forms approach: `reactive_forms` (used), `flutter_form_builder` (unused), `AppValidators` for plain `Form` (unused). Rewrite `AppValidators` as reactive_forms `Validator`s if you keep reactive_forms.
33. Remove or wire unused deps (section 1). Either delete them or add the matching feature: cache interceptor, connectivity banner, cached avatar image, shimmer skeleton, SVG assets, URL launcher helper.
34. `Logger` is only used by HTTP; add an app-level `AppLogger` (and forward warnings/errors to Sentry breadcrumbs).
35. Consider Riverpod codegen (`riverpod_generator`) + `riverpod_lint` to reduce boilerplate and catch provider mistakes.

## D. Platform / flavors
36. Flavors are Dart-only: dev and prod share bundle id, name and icon, so both cannot be installed side-by-side, and push/Firebase configs cannot differ. Add native flavors (Xcode schemes + Android `productFlavors`), e.g. `com.moslem.fluffle.dev`, "Fluffle Dev".
37. Commit the platform folders (at least after `flutter create`) so native config (permissions, flavors, icons, splash) is versioned; generating them in CI hides native changes.
38. Add `flutter_native_splash` and `flutter_launcher_icons` configs; the Dart splash appears after a white native launch screen.
39. `app.dart` title is hardcoded: use `onGenerateTitle: (c) => L10n.of(c).appTitle`.
40. Add a Persian font (e.g. Vazirmatn) with `fontFamily` per locale; `assets/fonts/` is empty and there is no `fonts:` section.

## E. Missing features worth adding to the new template
41. Forgot / reset password screens (API already there), email verification state (`emailVerifiedAt` exists).
42. Real Settings screen: change language, theme, logout, app version, privacy links (the theme onboarding text promises "change this any time in settings").
43. Real Edit Profile using `AppImagePickerSheet` + `image_picker` + `image_cropper` + `AppCharCounter` + `AppValidators` (these widgets exist for exactly this).
44. Password visibility toggle, `AutofillGroup` + `autofillHints`, submit on keyboard "done".
45. Connectivity awareness (offline banner, retry), HTTP cache for GETs.
46. Global `scaffoldMessengerKey` to show snackbars without `BuildContext` (e.g. from controllers).
47. Force-update / maintenance check in `appInitProvider` (the comment reserves the slot), remote config / feature flags (PostHog supports flags).
48. Deep links / universal links config for GoRouter.
49. Push notifications (FCM / APNs) with a notification service abstraction.
50. Analytics consent / opt-out (`Posthog().disable()`), and Sentry `beforeSend` scrubbing of PII.
51. Text scale clamping in `MaterialApp.builder` so large accessibility fonts do not break layouts; `Semantics` on `GestureDetector`-based widgets (snackbar action, read-only field).
52. An example feature built on `PaginatedAsyncNotifier` + `ApiListResponse` (list, search, infinite scroll, empty/error/shimmer states) to prove the pagination base works.

## F. Tooling / CI / tests
53. Tests to add: interceptors (401 → refresh → retry, concurrent 401s), `ErrorInterceptor` mapping table, `AuthRepositoryImpl` with mocktail, `AuthController` state transitions, router redirects (ProviderContainer + fake notifiers), `PaginatedAsyncNotifier`, golden tests for light/dark + RTL.
54. CI: add `dart format --set-exit-if-changed` on push to main, test coverage upload, a build job (`flutter build apk --debug` / `ios --no-codesign`), and cache pub + build_runner outputs.
55. Makefile: add `test`, `analyze`, `format`, `build-apk-dev`, and `run-dev` with `--dart-define` if you move away from envied.
56. l10n CI check: fail if any ARB key is missing in a locale (currently complete, but not enforced).
57. Add a `rename` script (package name + bundle id) since renaming is manual (find/replace across `lib/`).

---

## Porting checklist (what to copy into the new template)
- [ ] Bootstrap: `bootstrap(AppConfig)`, flavor entrypoints, fail-fast provider overrides
- [ ] envied env per flavor (+ `.env.example`, gitignore)
- [ ] `appInitProvider` + splash
- [ ] GoRouter: `RouterNotifier` bridge, onboarding redirect chain, `StatefulShellRoute` with per-tab navigators, screen tracking
- [ ] Onboarding: language + theme pickers, persisted choices
- [ ] Auth feature: barrel + `src/` layers, Retrofit API, repository with `Either`, controller returning `Failure?`, login/signup screens, `AuthGate`
- [ ] `currentUserNotifierProvider` session in core
- [ ] Dio stack: auth / refresh / logging / error interceptors, Sentry Dio
- [ ] Sealed `Failure` hierarchy
- [ ] Apiato response envelopes + `Paginated` + `PaginatedAsyncNotifier`
- [ ] L10n en/fa with RTL helpers
- [ ] Theme tokens (colors, spacing, radius, sizes, typography, effects, motion, styles) + `ThemeExtension`
- [ ] Widgets: snackbar, confirm dialog, image picker sheet, read-only field, char counter, haptic pull-to-refresh
- [ ] Utils: clipboard, validators
- [ ] Shell: bottom nav, re-tap scroll-to-top signal, unsaved-changes guard
- [ ] Analytics + ErrorReporter interfaces with PostHog / Sentry implementations
- [ ] Lints, Makefile, CI (auto-format + analyze/test), Dependabot + auto-merge, architecture test
- [ ] README conventions (provider naming, feature isolation, RTL, tokens)
