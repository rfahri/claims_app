import 'package:claims_app/core/utilities/app_constant.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient({String baseUrl = AppConstant.appUrl})
      : dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {
      'Accept': 'application/json',
    },
  )) {
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Response<T>> get<T>(String path) async => await dio.get(path);
  Future<Response<T>> post<T>(String path, {dynamic data}) async =>
      await dio.post(path, data: data);
  Future<Response<T>> put<T>(String path, {dynamic data}) async =>
      await dio.put(path, data: data);
  Future<Response<T>> delete<T>(String path) async => await dio.delete(path);
}
