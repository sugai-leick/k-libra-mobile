import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/network/auth_event_bus.dart';
import 'package:flutter_app/core/services/supabase_session_manager.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/core/services/remember_email_service.dart';
import 'package:flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';
import 'package:flutter_app/core/services/token_service.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final ITokenService tokenService;
  final SupabaseSessionManager supabaseSessionManager;
  final HttpService httpService;
  final IRememberEmailService rememberEmailService;
  StreamSubscription? _authEventSubscription;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.tokenService,
    required this.supabaseSessionManager,
    required this.httpService,
    required this.rememberEmailService,
  }) : super(AuthInitial()) {
    on<AuthCheckRememberedEmailRequested>(_onCheckRememberedEmail);
    
    // Escuta eventos globais de autenticação (ex: 401 Unauthorized do Interceptor)
    _authEventSubscription = AuthEventBus().stream.listen((event) {
      if (event == AuthEventType.sessionExpired) {
        add(AuthLogoutRequested());
      }
    });

    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      final token = await tokenService.getToken();
      
      if (token != null && token.isNotEmpty) {
        // Restaura a sessão do Supabase com o token persistido
        final refreshToken = await tokenService.getRefreshToken();
        await supabaseSessionManager.restoreSession(
          accessToken: token,
          refreshToken: refreshToken,
        );

        // --- VALIDAÇÃO REAL (Supabase + API) ---
        final isValid = await supabaseSessionManager.isSessionValid(httpService);
        
        if (isValid) {
          emit(AuthLoaded(
            authUser: AuthUser(
              id: 'cached_id', 
              email: 'cached_session@klibra.com', 
              role: 'authenticated', 
              accessToken: token,
              refreshToken: refreshToken,
            ),
          ));
        } else {
          await tokenService.deleteToken();
          await supabaseSessionManager.clearSession();
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      
      final result = await loginUsecase(
        LoginParams(
          email: event.params.email, 
          password: event.params.password,
        ),
      );

      await result.fold(
        (failure) async => emit(AuthError(msg: failure.msg)),
        (user) async {
          final token = await tokenService.getToken();
          final refreshToken = await tokenService.getRefreshToken();
          
          if (token != null && token.isNotEmpty) {
            await supabaseSessionManager.setSession(
              accessToken: token,
              refreshToken: refreshToken,
            );
          }
          
          emit(AuthLoaded(authUser: user));
        },
      );
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      
      final result = await logoutUsecase(NoParams());

      await result.fold(
        (failure) async => emit(AuthError(msg: failure.msg)),
        (_) async {
          await supabaseSessionManager.clearSession();
          emit(AuthInitial());
        },
      );
    });
  }

  Future<void> _onCheckRememberedEmail(
    AuthCheckRememberedEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final email = await rememberEmailService.getEmail();
      emit(AuthInitial(rememberedEmail: email));
    } catch (_) {
      emit(AuthInitial());
    }
  }

  @override
  Future<void> close() {
    _authEventSubscription?.cancel();
    return super.close();
  }
}
