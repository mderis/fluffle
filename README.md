# App Template

A Flutter starter template with batteries included: Riverpod state, GoRouter
navigation, Dio + Retrofit networking with auth/refresh interceptors, Freezed
models, fpdart `Either` error handling, secure-storage tokens, multi-flavor
envied configs, full L10n with RTL, Sentry monitoring, and PostHog analytics.

## What's in the box

| Concern         | Library / pattern                                   |
|-----------------|------------------------------------------------------|
| State           | `flutter_riverpod` 3.x (`AsyncNotifier`, `Provider`) |
| Routing         | `go_router` 17.x with `StatefulShellRoute` + redirect |
| HTTP            | `dio` + `retrofit` + auth/refresh/logging/error interceptors |
| Models          | `freezed` + `json_serializable`                     |
| Errors          | Sealed `Failure` + `fpdart` `Either<Failure, T>`    |
| Tokens          | `flutter_secure_storage` + queued refresh interceptor |
| Prefs           | `shared_preferences`                                |
| Forms           | `reactive_forms`                                    |
| Env             | `envied` per-flavor (`dev` / `prod`)                |
| L10n            | `flutter gen-l10n` (`en`, `fa` for RTL)             |
| Theme           | Centralized tokens (`AppColors`, `AppSpacing`, …) + `ThemeExtension` |
| Analytics       | `AnalyticsService` interface → PostHog              |
| Monitoring      | `ErrorReporter` interface → Sentry                  |
| HTTP cache      | `dio_cache_interceptor` (wired in pubspec)          |
| UI              | `cached_network_image`, `shimmer`, `flutter_svg`, `image_picker`, `image_cropper` |

## Architecture

Clean-ish architecture, organized by feature:

```
lib/
├── main.dart                       # Bootstrap (Sentry, PostHog, prefs)
├── main_dev.dart / main_prod.dart  # Flavor entrypoints
├── app.dart                        # MaterialApp.router
├── core/
│   ├── analytics/                  # AnalyticsService interface + PostHog impl
│   ├── api/                        # Dio + interceptors + base response shapes
│   ├── config/                     # AppConfig, Flavor enum, envied env files
│   ├── domain/                     # Generic entities (User, Paginated), Failure
│   ├── session/                    # currentUserNotifierProvider — app-wide signed-in user
│   ├── init/                       # appInitProvider — orchestrates startup
│   ├── l10n/                       # locale_notifier, supported_locales
│   ├── monitoring/                 # ErrorReporter interface + Sentry impl
│   ├── presentation/               # PaginatedAsyncNotifier base
│   ├── router/                     # GoRouter, AppRoutes, refresh listenable
│   ├── storage/                    # shared_preferences provider
│   ├── theme/                      # Colors, spacing, typography, motion, effects, theme
│   ├── utils/                      # AppClipboard
│   ├── validators/                 # AppValidators (l10n-aware)
│   └── widgets/                    # AppSnackBar, AppConfirmDialog, AuthGate, …
└── features/
    ├── auth/                       # Full skeleton — see "Feature layout" below
    ├── home/                       # Stub Home screen with dummy data
    ├── onboarding/                 # Splash → language → theme
    ├── profile/                    # Stub Profile + Edit Profile
    └── shell/                      # 2-tab bottom-nav shell
```

### Feature layout

Each feature is a self-contained module with a public API and private internals:

```
features/auth/
├── auth.dart                       # Public barrel — the ONLY thing other features import
└── src/                            # Private — never imported from outside this feature
    ├── application/                # Controllers + provider wiring
    ├── data/                       # API client, repository impl, DTOs
    ├── domain/                     # Entities, repository interface
    └── presentation/               # Grouped by screen (login/, signup/, …)
```

Cross-feature access goes through the barrel (e.g. `import 'package:app_template/features/auth/auth.dart'`). Reaching into another feature's `src/` is enforced against by `test/architecture/feature_boundary_test.dart` — it fails CI if anything imports `features/<x>/src/` from outside `features/<x>/`.

Shared state that multiple features need (current user, theme, locale) lives in `core/`, not in a feature. The owning feature *writes* to it; other features *read*. See `core/session/current_user_notifier.dart` for the canonical example.

## Setup for a new project

1. **Rename the package.** Replace `app_template` with your project name in:
   - `pubspec.yaml` (`name:` field)
   - All `package:app_template/...` imports (find/replace across `lib/`)
   - `analysis_options.yaml` (no change needed)
2. **Generate platform folders.** Inside the project directory:
   ```sh
   flutter create . --org com.example --project-name <your_name>
   ```
3. **Install dependencies:**
   ```sh
   flutter pub get
   ```
4. **Set up env files.** Copy `.env.example` → `.env.dev` and `.env.prod`,
   then fill in real values. Required keys: `API_BASE_URL`,
   `AUTH_CLIENT_ID`, `AUTH_CLIENT_SECRET`, `POSTHOG_API_KEY`,
   `POSTHOG_HOST`, `SENTRY_DSN`. Leave any unused ones blank.
5. **Run code generation** (envied + freezed + json_serializable + retrofit + l10n):
   ```sh
   make rebuild
   ```
   Or manually:
   ```sh
   dart run build_runner build
   flutter gen-l10n
   ```
6. **Run dev:**
   ```sh
   make run-dev
   ```

## GitHub repository setup

CI assumes certain GitHub settings. Configure these once after your first push.

### Branch protection rule (Settings → Branches → Add ruleset, target `main`)

| Setting | Status | Why |
|---|---|---|
| Require a pull request before merging | **Required** | Ensures CI runs before merge. |
| Require status checks: `Auto-format`, `Analyze & Test` | **Required** | Both must be green to merge. |
| Require signed commits | **Must be OFF** | Auto-format bot's commits aren't signed. |
| Require branches to be up to date | Recommended | Avoids merging stale PRs. |
| Require linear history | Recommended | Cleaner main; pair with squash merge. |
| Require conversation resolution | Recommended | Surfaces unaddressed review comments. |
| Require approvals | Optional | Off for solo dev. Set to ≥1 for teams. |
| Allow force pushes / deletions | OFF | Standard safety. |

### Pull request merge options (Settings → General → Pull Requests)

| Setting | Status |
|---|---|
| Allow merge commits | **Disable** (conflicts with linear history). |
| Allow squash merging | Enable (matches Dependabot auto-merge). |
| Allow rebase merging | Optional. |

### Local git credentials

Pushing changes to `.github/workflows/*` requires the `workflow` scope on your
GitHub credential:

```sh
gh auth refresh -s workflow
```

Or regenerate your PAT with the `workflow` scope at github.com/settings/tokens.

## Onboarding flow

First launch routes through:

1. **Splash** — waits for `appInitProvider` (locale + theme + auth bootstrap)
2. **Language picker** — persists choice to SharedPreferences (`locale` key)
3. **Theme picker** — Light / Dark / System, persists to `theme_mode` key
4. **Home** — bottom-nav shell

The router redirect logic in `core/router/app_router.dart` enforces this
order. Once both choices are stored, subsequent launches go straight to Home.

## Auth

`features/auth/` ships a full OAuth2 password-grant skeleton:

- **API** (`auth_api.dart`) — Retrofit endpoints: `/v1/oauth/token`,
  `/v1/register`, `/v1/logout`, `/v1/user/profile`, `/v1/forgotpassword`,
  `/v1/resetpassword`, `/v1/user`.
- **Repository** stores access + refresh tokens in
  `flutter_secure_storage`. The `RefreshInterceptor` automatically refreshes
  on 401 and retries the original request.
- **`AuthGate` widget** swaps between an authenticated child and a login
  screen based on `currentUserNotifierProvider` (in `core/session/`).

Adapt the endpoints in `auth_api.dart` to your backend. If you don't use
OAuth2 password grant, simplify the request body in `auth_repository_impl.dart`.

## Conventions enforced by the codebase

- **No hardcoded text** in UI — every string goes through `L10n.of(context)`
- **No hardcoded sizes / spacing / radii** — use `AppSpacing`, `AppRadius`,
  `AppSizes`, `AppFontSize`
- **Colors via `context.colors.X`** (the `AppColorsExtension`), not raw `Color(...)`
- **Use `EdgeInsetsDirectional`** + `PositionedDirectional` so RTL works
- **Haptic feedback** on tap-driven UI (see `HapticFeedback.selectionClick`)

### Provider naming

Every Riverpod global ends in `xxxProvider` (the universal Riverpod suffix).
The **middle word** names what's behind the provider, and that tells you both
the backing class and how to use it at the call site:

| Variable | Backing class | Call-site idiom |
|---|---|---|
| `xxxNotifierProvider` | `XxxNotifier extends Notifier<T>` | `ref.watch(...)` for state |
| `xxxControllerProvider` | `XxxController extends AsyncNotifier<…>` | `ref.read(....notifier).method()` for ops |
| `xxxSignalProvider` | `XxxSignal extends Notifier<Event>` | `ref.listen(...)` for one-shot events |
| `xxxRepositoryProvider` / `xxxApiProvider` | service class | `ref.read(...).method()` |
| `xxxProvider` (bare) | `Provider<T>` or `FutureProvider<T>` | `ref.watch(...)` returns `T` directly |

Concretely: a `Notifier` *holds state* (you read its `state`), a `Controller`
*orchestrates operations* (you call its methods via `.notifier`), a
`Repository`/`Api` is a *service* (DI wiring, you call its methods directly).
The naming makes the intent visible without opening the file.

### Feature isolation

- A feature exposes its public API through a single barrel file
  (`features/<name>/<name>.dart`). External code may **only** import that.
- A feature's `src/` is private. The boundary is enforced by
  `test/architecture/feature_boundary_test.dart` — CI fails if anything
  imports `features/<x>/src/...` from outside `features/<x>/`.
- Shared state graduates to `core/`. Owning feature writes; other features read.

## Removing pieces you don't need

- **Drop auth:** delete `features/auth/` and `core/session/`, remove `AuthGate`
  from `app_router.dart`, remove `authControllerProvider` reference from
  `appInitProvider`. Also delete `secureStorageProvider` from `dio_provider.dart`
  and the auth + refresh interceptors.
- **Drop PostHog:** remove from `pubspec.yaml`, delete
  `posthog_analytics_service.dart` and `Posthog().setup(...)` from
  `main.dart`. Replace `analyticsProvider` with a no-op implementation of
  `AnalyticsService`.
- **Drop Sentry:** remove from `pubspec.yaml`, delete
  `sentry_error_reporter.dart`, replace the `SentryFlutter.init(...)` block
  in `main.dart` with `runApp(...)` directly. Replace `errorReporterProvider`
  with a no-op.
