import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/clients/domain/repositories/customers_repository.dart';

class TotalCustomersUsecase implements StreamUsecase<NoParams, int> {
  final ICustomersRepository repository;

  TotalCustomersUsecase({required this.repository});

  @override
  Stream<Either<Failure, int>> call(NoParams params) {
    return repository.getTotalCustomers();
  }
}
