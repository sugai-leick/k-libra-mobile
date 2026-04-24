part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final LoginParams params;

  AuthLoginRequested({required this.params});

}

class AuthLogoutRequested extends AuthEvent {}

class AuthSendPasswordResetRequested extends AuthEvent {
  final String email;
  AuthSendPasswordResetRequested({required this.email});
}
