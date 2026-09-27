import 'package:fluffle/core/presentation/failure_message.dart';
import 'package:fluffle/core/result/failure.dart';
import 'package:fluffle/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<L10n> loadL10n(String languageCode) =>
      L10n.delegate.load(Locale(languageCode));

  test('every failure maps to a non-empty message in every locale', () async {
    const failures = <Failure>[
      NetworkFailure(.offline),
      NetworkFailure(.timeout),
      NetworkFailure(.badCertificate),
      CancelledFailure(),
      UnauthorizedFailure(),
      ForbiddenFailure(),
      NotFoundFailure(),
      ValidationFailure(),
      ServerFailure(statusCode: 500),
      UnexpectedFailure('boom'),
    ];
    for (final locale in L10n.supportedLocales) {
      final l10n = await loadL10n(locale.languageCode);
      for (final failure in failures) {
        expect(failure.message(l10n), isNotEmpty, reason: '$failure/$locale');
      }
    }
  });

  test('validation failures prefer the server message', () async {
    final l10n = await loadL10n('en');
    const failure = ValidationFailure(serverMessage: 'Email is taken.');
    expect(failure.message(l10n), 'Email is taken.');
  });

  test('server messages are never shown for other failures', () async {
    final l10n = await loadL10n('fa');
    const failure = ServerFailure(statusCode: 500, serverMessage: 'Oops');
    expect(failure.message(l10n), l10n.errorServer);
  });
}
