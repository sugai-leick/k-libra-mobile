import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';

class LoginUsecase implements Usecase<LoginParams, AuthUser> {
  final IAuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, AuthUser>> call(LoginParams params) async {
    return await authRepository.login(params);
  }
}
