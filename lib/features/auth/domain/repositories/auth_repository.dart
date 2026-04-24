import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';

abstract class IAuthRepository {
  Future<Either<Failure, AuthUser>> login(LoginParams params);
  Future<Either<Failure, Success>> logout();
  Future<Either<Failure, Success>> sendPasswordResetEmail(String email);
  Future<Either<Failure, bool>> isLoggedIn();
}
