import 'package:claims_app/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

@GenerateMocks([MockInternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockMockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        final tHasConnection = Future.value(true);

        when(
          mockInternetConnectionChecker.hasConnection,
        ).thenAnswer((_) => tHasConnection);

        final result = networkInfoImpl.isConnected;

        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, tHasConnection);
      },
    );
  });
}
