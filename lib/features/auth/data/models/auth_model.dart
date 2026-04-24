import 'package:flutter_app/features/auth/domain/entities/auth_user.dart';

class AuthModel extends AuthUser {
  const AuthModel({
    required super.id,
    required super.email,
    required super.role,
    super.accessToken,
    super.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    return AuthModel(
      id: userJson['id'] as String,
      email: userJson['email'] as String,
      role: userJson['role'] as String,
      accessToken: (json['access_token'] ?? json['accessToken']) as String?,
      refreshToken: (json['refresh_token'] ?? json['refreshToken']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user': {
        'id': id,
        'email': email,
        'role': role,
      },
    };
  }
}
