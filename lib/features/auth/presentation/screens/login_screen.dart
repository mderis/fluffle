import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:app_template/core/router/app_routes.dart';
import 'package:app_template/core/theme/app_effects.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/core/widgets/app_snack_bar.dart';
import 'package:app_template/features/auth/presentation/providers/auth_notifier.dart';
import 'package:app_template/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = FormGroup({
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
  });

  String? _errorMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.xl,
            ),
            child: ReactiveForm(
              formGroup: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.login,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  ReactiveTextField<String>(
                    formControlName: 'email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ReactiveTextField<String>(
                    formControlName: 'password',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: null,
                      child: Text(l10n.forgotPassword),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: _isLoading ? null : _onLogin,
                    child: _isLoading
                        ? const SizedBox(
                            height: AppSpacing.lg,
                            width: AppSpacing.lg,
                            child: CircularProgressIndicator(
                              strokeWidth: AppStroke.thick,
                            ),
                          )
                        : Text(l10n.login),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.signup),
                    child: Text(l10n.signup),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    _form.markAllAsTouched();
    if (!_form.valid) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final failure = await ref
        .read(authNotifierProvider.notifier)
        .login(
          email: _form.control('email').value as String,
          password: _form.control('password').value as String,
        );

    if (!mounted) return;

    if (failure == null) {
      AppSnackBar.success(
        context,
        message: L10n.of(context).loginSuccess,
        haptic: true,
      );
      context.go(AppRoutes.home);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = failure.message;
      });
    }
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
}
