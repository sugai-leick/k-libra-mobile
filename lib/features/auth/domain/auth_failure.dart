import 'package:flutter_app/core/failures/failure.dart';

class AuthFailure extends Failure {
  AuthFailure({required super.msg});
}

class LoginFailure extends AuthFailure {
  LoginFailure({required super.msg});
}

class LogoutFailure extends AuthFailure {
  LogoutFailure({required super.msg});
}

class SendPasswordResetEmailFailure extends AuthFailure {
  SendPasswordResetEmailFailure({required super.msg});
}