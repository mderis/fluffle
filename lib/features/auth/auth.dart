/// Public API for the auth feature.
///
/// Other features and the app shell may **only** import from this barrel —
/// never reach into `src/` directly. That keeps the feature's internals free
/// to change without breaking callers.
///
/// What's intentionally *not* exported: the API client, repository, DTOs,
/// and individual use cases — all of those are implementation details.
///
/// For "who is the currently signed-in user", read
/// `package:app_template/core/session/current_user_notifier.dart` instead —
/// that's app-wide session state, not auth-feature state.
///
/// ## Project convention: Notifier vs Controller
///
/// Both are Riverpod `Notifier` subclasses, but the suffix signals intent:
///
/// - **`XxxNotifier`** — *holds state*. The `state` IS the value you care
///   about. Read with `ref.watch(xxxProvider)` to get the value.
///   Example: `CurrentUserNotifier` (state = `User?`).
///
/// - **`XxxController`** — *orchestrates operations*. The `state` is usually
///   `AsyncValue<void>` (idle/loading/error); the real point is its methods.
///   Read with `ref.read(xxxControllerProvider.notifier).someMethod()`.
///   Example: `AuthController.login(...)`.
///
/// This mirrors Flutter's own `*Controller` types (TextEditingController,
/// ScrollController, AnimationController) — objects you imperatively command.
library;

export 'src/application/auth_controller.dart' show authControllerProvider;
export 'src/presentation/login/login_screen.dart' show LoginScreen;
export 'src/presentation/signup/signup_screen.dart' show SignupScreen;
