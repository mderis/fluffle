import 'package:fluffle/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Ok exposes its value', () {
      const result = Result<int>.ok(42);
      expect(result.isOk, isTrue);
      expect(result.valueOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('Err exposes its failure', () {
      const failure = NetworkFailure(.offline);
      const result = Result<int>.err(failure);
      expect(result.isOk, isFalse);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, same(failure));
    });

    test('map transforms Ok and passes Err through', () {
      expect(const Result<int>.ok(2).map((v) => v * 2).valueOrNull, 4);

      const failure = ServerFailure(statusCode: 500);
      final mapped = const Result<int>.err(failure).map((v) => v * 2);
      expect(mapped.failureOrNull, same(failure));
    });
  });
}
