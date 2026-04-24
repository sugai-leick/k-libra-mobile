import 'package:dio/dio.dart';
import 'package:flutter_app/core/network/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpService {
  final Dio dio;

  HttpService(this.dio, AuthInterceptor authInterceptor) {
    dio.options.baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3001/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    
    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    )); // Útil para debug
  }

  // Métodos auxiliares para facilitar as chamadas em todo o app
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }
}
