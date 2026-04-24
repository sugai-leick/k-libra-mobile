import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/services/supabase_session_manager.dart';
import 'package:flutter_app/core/services/token_service.dart';
import 'package:flutter_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_app/features/auth/domain/auth_failure.dart';
import 'package:flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  final ITokenService tokenService;
  final SupabaseSessionManager supabaseSessionManager;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
    required this.supabaseSessionManager,
  });

  @override
  Future<Either<Failure, AuthUser>> login(LoginParams params) async {
    try {
      final authModel = await remoteDataSource.login(params);

      // Salva ambos os tokens localmente no Secure Storage
      if (authModel.accessToken != null) {
        await tokenService.saveTokens(
          accessToken: authModel.accessToken!,
          refreshToken: authModel.refreshToken,
          rememberMe: params.rememberMe,
        );

        // Injeta a sessão no SupabaseClient para queries diretas e Realtime
        await supabaseSessionManager.setSession(
          accessToken: authModel.accessToken!,
          refreshToken: authModel.refreshToken,
        );
      } else {
      }

      return Right(authModel);
    } on AppException catch (e) {
      return Left(LoginFailure(msg: e.message));
    } catch (e) {
      return Left(LoginFailure(msg: 'Erro inesperado'));
    }
  }

  @override
  Future<Either<Failure, Success>> logout() async {
    try {
      await remoteDataSource.logout();
      // Limpa sessão do Supabase e tokens locais
      await supabaseSessionManager.clearSession();
      await tokenService.clearTokens();
      return Right(Success(msg: 'Logout realizado com sucesso'));
    } catch (e) {
      return Left(LogoutFailure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final hasToken = await tokenService.hasToken();
      return Right(hasToken);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, Success>> sendPasswordResetEmail(String email) async {
    // Para simplificar, poderíamos implementar um endpoint na API se necessário
    return Left(
      SendPasswordResetEmailFailure(
        msg: 'Funcionalidade não disponível via API REST no momento.',
      ),
    );
  }
}
