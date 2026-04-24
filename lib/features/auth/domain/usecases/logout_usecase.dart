import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase implements Usecase<NoParams, Success> {
  final IAuthRepository authRepo;

  LogoutUsecase({required this.authRepo});

  @override
  Future<Either<Failure, Success>> call(NoParams params) async {
    return await authRepo.logout();
  }
}


