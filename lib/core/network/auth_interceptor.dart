import 'package:dio/dio.dart';
import 'package:flutter_app/core/network/auth_event_bus.dart';
import 'package:flutter_app/core/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final ITokenService _tokenService;

  AuthInterceptor(this._tokenService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokenService.getToken();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
    }
    
    return handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Se a API retornar um novo access_token em qualquer resposta, nós o atualizamos
    if (response.data is Map && (response.data['access_token'] != null || response.data['accessToken'] != null)) {
      final newToken = (response.data['access_token'] ?? response.data['accessToken']) as String;
      await _tokenService.saveToken(newToken);
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Evita loop infinito: se o 401 aconteceu no próprio logout, não notificamos de novo
      final isLogoutRequest = err.requestOptions.path.contains('logout');

      if (!isLogoutRequest) {
        await _tokenService.deleteToken();
        AuthEventBus().emit(AuthEventType.sessionExpired);
      } else {
        // No logout com 401, apenas garantimos que o token local seja limpo
        await _tokenService.deleteToken();
      }
    }
    return handler.next(err);
  }
}
