import 'package:fluffle/core/result/failure.dart';

export 'package:fluffle/core/result/failure.dart';

/// The outcome of an operation that can fail: [Ok] with a value, or [Err]
/// with a [Failure].
///
/// Repositories return `Result` instead of throwing, so callers are forced
/// by the type system to handle failure. Consume it with pattern matching:
///
/// ```dart
/// switch (await repository.fetchProfile()) {
///   case Ok(:final value):
///     showProfile(value);
///   case Err(:final failure):
///     showError(failure);
/// }
/// ```
///
/// This follows the Result pattern from Flutter's official architecture
/// guide, with a sealed [Failure] instead of a raw exception.
sealed class const Result<T>() {
  /// A successful result holding [value].
  const factory ok(T value) = Ok<T>;

  /// A failed result holding [failure].
  const factory err(Failure failure) = Err<T>;

  /// Whether this is an [Ok].
  bool get isOk => this is Ok<T>;

  /// The value, or `null` when this is an [Err].
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  /// The failure, or `null` when this is an [Ok].
  Failure? get failureOrNull => switch (this) {
    Ok() => null,
    Err(:final failure) => failure,
  };

  /// Transforms the value of an [Ok], passing an [Err] through unchanged.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok(:final value) => Ok(transform(value)),
    Err(:final failure) => Err(failure),
  };
}

/// A successful [Result].
final class const Ok<T>(final T value) extends Result<T>;

/// A failed [Result].
final class const Err<T>(final Failure failure) extends Result<T>;
