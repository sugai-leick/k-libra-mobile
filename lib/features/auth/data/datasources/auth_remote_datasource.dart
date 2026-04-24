import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/features/auth/data/models/auth_model.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';
import 'package:dio/dio.dart';

abstract class IAuthRemoteDataSource {
  Future<AuthModel> login(LoginParams params);
  Future<Success> logout();
}

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final HttpService _httpService;

  AuthRemoteDataSource(this._httpService);

  @override
  Future<AuthModel> login(LoginParams params) async {
    try {
      final response = await _httpService.post(
        '/auth/login',
        data: {'email': params.email, 'password': params.password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        
        return AuthModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AppException(
          message: 'Falha na autenticação. Verifique suas credenciais.',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw AppException(message: 'E-mail ou senha incorretos.');
      }
      // Printando o verdadeiro porque ocorreu falha de rede para debug
      throw AppException(
        message:
            'Rede/Servidor inacessível: ${e.message ?? e.error.toString()}',
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(message: 'Ocorreu um erro no aplicativo.');
    }
  }

  @override
  Future<Success> logout() async {
    try {
      await _httpService.post('/auth/logout');
      return Success(msg: 'Logout realizado com sucesso');
    } catch (e) {
      // Mesmo se falhar na API, consideramos logout no lado do cliente
      return Success(msg: 'Logout realizado localmente');
    }
  }
}
