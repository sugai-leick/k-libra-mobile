import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/auth/domain/usecases/params/login_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepo {
  Future<Either<Failure, Success>> logout();
  Future<Either<Failure, AuthResponse>> login(LoginParams params);
  Future<Either<Failure, Success>> sendPasswordResetEmail(String email);
}
