import 'package:claims_app/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ServerFailure holds message', () {
    final f = ServerFailure('Server Error');
    expect(f.message, 'Server Error');
  });

  test('NetworkFailure holds message', () {
    final f = NetworkFailure('No internet');
    expect(f.message, 'No internet');
  });
}
