import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String role;
  final String? accessToken;
  final String? refreshToken;

  const AuthUser({
    required this.id,
    required this.email,
    required this.role,
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [id, email, role, accessToken, refreshToken];
}
