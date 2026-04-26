import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app_template/core/analytics/analytics_provider.dart';
import 'package:app_template/core/init/app_init_provider.dart';
import 'package:app_template/core/l10n/locale_provider.dart';
import 'package:app_template/core/router/app_routes.dart';
import 'package:app_template/core/theme/theme_provider.dart';
import 'package:app_template/core/widgets/auth_gate.dart';
import 'package:app_template/features/auth/presentation/screens/login_screen.dart';
import 'package:app_template/features/auth/presentation/screens/signup_screen.dart';
import 'package:app_template/features/home/presentation/screens/home_screen.dart';
import 'package:app_template/features/onboarding/presentation/screens/language_picker_screen.dart';
import 'package:app_template/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:app_template/features/onboarding/presentation/screens/theme_picker_screen.dart';
import 'package:app_template/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:app_template/features/profile/presentation/screens/profile_screen.dart';
import 'package:app_template/features/shell/presentation/screens/main_shell_screen.dart';

// Navigator keys — one per branch that needs its own stack.
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

/// Bridges Riverpod state → [ChangeNotifier] so [GoRouter.refreshListenable]
/// re-evaluates redirects without rebuilding the router.
///
/// Only listens to state that affects routing decisions:
/// - App initialization (splash → app)
/// - Locale chosen (onboarding → app)
/// - Theme chosen (onboarding → app)
final _routerNotifierProvider =
    Provider<RouterNotifier>((ref) => RouterNotifier(ref));

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(appInitProvider, (_, _) => notifyListeners());
    _ref.listen(localeProvider, (prev, next) {
      if ((prev?.value != null) != (next.value != null)) notifyListeners();
    });
    _ref.listen(themeModeProvider, (prev, next) {
      if ((prev?.value != null) != (next.value != null)) notifyListeners();
    });
  }

  bool get isAppReady => !_ref.read(appInitProvider).isLoading;
  bool get hasChosenLocale => _ref.read(localeProvider).value != null;
  bool get hasChosenTheme => _ref.read(themeModeProvider).value != null;
}

/// Friendly screen names for analytics.
const _screenNames = <String, String>{
  '/splash': 'Splash',
  '/login': 'Login',
  '/signup': 'Sign Up',
  '/onboarding/language': 'Onboarding · Language',
  '/onboarding/theme': 'Onboarding · Theme',
  '/home': 'Home',
  '/profile': 'Profile',
  '/profile/edit': 'Edit Profile',
  '/settings': 'Settings',
};

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);
  final analytics = ref.watch(analyticsProvider);

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // Still initializing — stay on / go to splash
      if (!notifier.isAppReady) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      // First launch — needs language selection
      if (!notifier.hasChosenLocale) {
        return location == AppRoutes.onboardingLanguage
            ? null
            : AppRoutes.onboardingLanguage;
      }

      // Then theme selection
      if (!notifier.hasChosenTheme) {
        return location == AppRoutes.onboardingTheme
            ? null
            : AppRoutes.onboardingTheme;
      }

      // App is ready — redirect away from splash/onboarding
      if (location == AppRoutes.splash ||
          location == AppRoutes.onboardingLanguage ||
          location == AppRoutes.onboardingTheme) {
        return AppRoutes.home;
      }

      // Everything else — let through (auth is not a routing concern)
      return null;
    },
    routes: [
      // Splash (shown while loading auth/locale/theme)
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes (outside shell)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboardingLanguage,
        builder: (context, state) => const LanguagePickerScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingTheme,
        builder: (context, state) => const ThemePickerScreen(),
      ),

      // ── Main app with bottom navigation ──
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          // Branch 0 — Home
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),

          // Branch 1 — Profile
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AuthGate(
                    authenticated: ProfileScreen(),
                    unauthenticated: LoginScreen(),
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Settings (full-screen, outside shell)
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const _Placeholder('Settings'),
      ),
    ],
  );

  // Track screen views — listens to both providers to capture tab switches
  // AND within-branch pops. Deduplicates by last path to avoid double-tracking.
  String? lastPath;
  void trackScreen() {
    final path = router.routeInformationProvider.value.uri.path;
    if (path == lastPath) return;
    lastPath = path;
    final name = _screenNames[path] ?? path;
    analytics.screen(name: name);
  }

  router.routeInformationProvider.addListener(trackScreen);
  router.routerDelegate.addListener(trackScreen);

  return router;
});

class _Placeholder extends StatelessWidget {
  final String title;

  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title screen')),
    );
  }
}
