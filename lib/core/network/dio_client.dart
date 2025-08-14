import 'package:claims_app/core/utilities/app_constant.dart';
import 'package:dio/dio.dart';

import '../errors/error_handler.dart';
import 'network_info.dart';

class DioClient {
  late final Dio _dio;
  final NetworkInfo _networkInfo;

  DioClient(this._dio, this._networkInfo) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        // onError: _onError,
      ),
    );
  }

  _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (await _networkInfo.isConnected) {
      return handler.next(options);
    } else {
      return handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: ResponseCode.noInternetConnection,
            statusMessage: ResponseMessage.noInternetConnection,
          ),
          error: ResponseMessage.noInternetConnection,
        ),
      );
    }
  }

  Future<Response> get({
    required String endPoint,
    dynamic data,
    dynamic params,
  }) async {
    var response = await _dio.get(
      '${AppConstant.appUrl}$endPoint',
      data: data,
      queryParameters: params,
    );
    return response;
  }

  Future<Response> post({
    required String endPoint,
    dynamic data,
    dynamic params,
  }) async {
    var response = await _dio.post(
      '${AppConstant.appUrl}$endPoint',
      data: data,
      queryParameters: params,
    );
    return response;
  }
}
