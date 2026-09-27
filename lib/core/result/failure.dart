/// Why an operation failed, as seen by the domain and UI layers.
///
/// Failures carry facts, not user-facing text. The presentation layer turns
/// them into localized messages (see `failure_message.dart`), so switching
/// the app language also changes error messages.
///
/// The hierarchy is sealed: a `switch` over a [Failure] must handle every
/// case, and adding a case makes the compiler point at every place that
/// needs updating.
sealed class const Failure();

/// What went wrong on the network level.
enum NetworkIssue {
  /// No connection, DNS failure, socket error.
  offline,

  /// Connect, send or receive timeout.
  timeout,

  /// The TLS certificate was rejected.
  badCertificate,
}

/// The request never got a usable response.
final class const NetworkFailure(final NetworkIssue issue) extends Failure;

/// The request was cancelled on purpose (for example a superseded search).
///
/// Usually ignored by the UI.
final class const CancelledFailure() extends Failure;

/// The session is missing or expired (HTTP 401).
final class const UnauthorizedFailure({final String? serverMessage})
    extends Failure;

/// The user is signed in but not allowed to do this (HTTP 403).
final class const ForbiddenFailure({final String? serverMessage})
    extends Failure;

/// The requested resource does not exist (HTTP 404).
final class const NotFoundFailure({final String? serverMessage})
    extends Failure;

/// The server rejected the input (HTTP 422).
///
/// [fieldErrors] maps field names to messages, as returned by Laravel,
/// so forms can show them next to the right input.
final class const ValidationFailure({
  final String? serverMessage,
  final Map<String, List<String>> fieldErrors = const {},
}) extends Failure;

/// Any other error response from the server (4xx or 5xx).
final class const ServerFailure({
  final int? statusCode,
  final String? serverMessage,
}) extends Failure;

/// A bug or an unexpected condition in the app itself.
///
/// Always reported to crash reporting.
final class const UnexpectedFailure(
  final Object error, [
  final StackTrace? stackTrace,
]) extends Failure;
