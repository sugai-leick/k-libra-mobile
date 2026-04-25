part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {
  final String? rememberedEmail;
  AuthInitial({this.rememberedEmail});
}

final class AuthLoading extends AuthState {}

final class AuthLoaded extends AuthState {
  final AuthUser authUser;
  AuthLoaded({required this.authUser});
}

final class AuthError extends AuthState {
  final String msg;
  AuthError({required this.msg});
}
