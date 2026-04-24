import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/features/auth/domain/auth_failure.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthSource {
  Future<Success> logout();
  Future<AuthResponse> login(LoginParams params);
  Future<Success> sendPasswordResetEmail(String email);
}

class AuthSource implements IAuthSource {
  final SupabaseClient supabaseClient;

  AuthSource({required this.supabaseClient});
  @override
  Future<AuthResponse> login(LoginParams params) async {
    try {
      await supabaseClient.auth.signInWithPassword(
        email: params.email,
        password: params.password,
      );
      return AuthResponse();
    } on AuthException catch (e) {
      if (e.message == 'Invalid login credentials') {
        throw AppException(
          message: 'E-mail ou senha incorretos. Verifique seus dados.',
        );
      }
      throw AppException(
        message: 'Ocorreu um erro inesperado ao tentar entrar.',
      );
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<Success> logout() async {
    try {
      await supabaseClient.auth.signOut();
      return Success(msg: 'Logout realizado com sucesso');
    } on AuthException catch (e) {
      throw LogoutFailure(msg: e.toString());
    } catch (e) {
      throw LogoutFailure(msg: e.toString());
    }
  }

  @override
  Future<Success> sendPasswordResetEmail(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
      return Success(msg: 'Email de redefinição de senha enviado com sucesso');
    } on AuthException catch (e) {
      throw SendPasswordResetEmailFailure(msg: e.toString());
    } catch (e) {
      throw SendPasswordResetEmailFailure(msg: e.toString());
    }
  }
}
