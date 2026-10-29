import 'package:doc_find/core/utils/failure.dart';
import 'package:doc_find/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success holds data and returns true for isSuccess', () {
      final Result<String> result = Result.success('hello');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 'hello');
      expect(result.failureOrNull, isNull);

      final String transformed = result.when(
        success: (data) => 'got $data',
        failure: (f) => 'fail',
      );
      expect(transformed, 'got hello');
    });

    test('FailureResult holds failure and returns true for isFailure', () {
      const Failure failure = ValidationFailure('Invalid input', 'E01');
      final Result<String> result = Result.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, failure);

      final String message = result.when(
        success: (data) => 'success',
        failure: (f) => f.message,
      );
      expect(message, 'Invalid input');
    });

    test('map transforms success data and leaves failure intact', () {
      final Result<int> successResult = Result.success(10);
      final Result<String> mappedSuccess = successResult.map((n) => 'num: $n');
      expect(mappedSuccess.dataOrNull, 'num: 10');

      const Failure failure = NetworkFailure('Offline');
      final Result<int> failureResult = Result.failure(failure);
      final Result<String> mappedFailure = failureResult.map((n) => 'num: $n');
      expect(mappedFailure.failureOrNull, failure);
    });
  });
}
