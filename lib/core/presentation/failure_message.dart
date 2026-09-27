import 'package:fluffle/core/result/failure.dart';
import 'package:fluffle/l10n/generated/app_localizations.dart';

/// Localized, user-facing text for a [Failure].
extension FailureMessage on Failure {
  /// A message suitable for a snackbar or an inline error.
  ///
  /// Server-provided messages are only used for validation errors, where the
  /// backend explains what to fix. Everything else uses our own translated
  /// copy, so the app never shows raw English server text in Persian.
  String message(L10n l10n) => switch (this) {
    NetworkFailure(issue: .offline) => l10n.errorOffline,
    NetworkFailure(issue: .timeout) => l10n.errorTimeout,
    NetworkFailure(issue: .badCertificate) => l10n.errorBadCertificate,
    CancelledFailure() => l10n.errorUnexpected,
    UnauthorizedFailure() => l10n.errorUnauthorized,
    ForbiddenFailure() => l10n.errorForbidden,
    NotFoundFailure() => l10n.errorNotFound,
    ValidationFailure(:final serverMessage) =>
      serverMessage ?? l10n.errorValidation,
    ServerFailure() => l10n.errorServer,
    UnexpectedFailure() => l10n.errorUnexpected,
  };
}
