import 'package:claims_app/core/network/dio_client.dart';
import 'package:claims_app/core/network/network_info.dart';
import 'package:claims_app/core/utilities/app_constant.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dio_client_test.mocks.dart';

@GenerateMocks([NetworkInfo])
void main() {
  late Dio dio;
  late MockNetworkInfo mockNetworkInfo;
  late DioClient dioClient;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio();
    mockNetworkInfo = MockNetworkInfo();
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;

    dioClient = DioClient(dio, mockNetworkInfo);
  });

  group('DioClient Interceptor Tests', () {
    test('GET request proceeds when internet is available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      dioAdapter.onGet(
        '${AppConstant.appUrl}test',
            (server) => server.reply(200, {'message': 'success'}),
      );

      // Act
      final result = await dioClient.get(endPoint: 'test');

      // Assert
      expect(result.data['message'], 'success');
    });

    test('GET request throws DioException when internet is NOT available',
            () async {
          // Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

          // Act & Assert
          expect(
                () async => await dioClient.get(endPoint: 'test'),
            throwsA(isA<DioException>()),
          );
        });
  });
}
