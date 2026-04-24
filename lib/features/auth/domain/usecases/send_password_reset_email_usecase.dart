import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmailUsecase implements Usecase<String, Success> {
  final IAuthRepository authRepo;

  SendPasswordResetEmailUsecase({required this.authRepo});

  @override
  Future<Either<Failure, Success>> call(String email) async {
    return await authRepo.sendPasswordResetEmail(email);
  }
}
