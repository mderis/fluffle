import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:app_template/core/router/app_routes.dart';
import 'package:app_template/core/theme/app_effects.dart';
import 'package:app_template/core/theme/app_spacing.dart';
import 'package:app_template/features/auth/presentation/providers/auth_notifier.dart';
import 'package:app_template/l10n/app_localizations.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _form = FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
    ),
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
    ),
    'password': FormControl<String>(
      validators: [Validators.required, Validators.minLength(8)],
    ),
    'password_confirmation': FormControl<String>(
      validators: [Validators.required],
    ),
  }, validators: [
    Validators.mustMatch('password', 'password_confirmation'),
  ]);

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
                horizontal: AppSpacing.xl),
            child: ReactiveForm(
              formGroup: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.signup,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  ReactiveTextField<String>(
                    formControlName: 'name',
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.name,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ReactiveTextField<String>(
                    formControlName: 'password_confirmation',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: _isLoading ? null : _onSignup,
                    child: _isLoading
                        ? const SizedBox(
                            height: AppSpacing.lg,
                            width: AppSpacing.lg,
                            child: CircularProgressIndicator(
                              strokeWidth: AppStroke.thick,
                            ),
                          )
                        : Text(l10n.signup),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: Text(l10n.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSignup() async {
    _form.markAllAsTouched();
    if (!_form.valid) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final failure = await ref.read(authNotifierProvider.notifier).register(
          name: _form.control('name').value as String,
          email: _form.control('email').value as String,
          password: _form.control('password').value as String,
          passwordConfirmation:
              _form.control('password_confirmation').value as String,
        );

    if (!mounted) return;

    if (failure == null) {
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
