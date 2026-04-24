import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/repositories/customers_repository.dart';

class GetStudentsUseCase {
  final ICustomersRepository repository;

  GetStudentsUseCase({required this.repository});

  Future<Either<Failure, List<CustomerEntity>>> call() async {
    // Filtramos apenas por alunos no repositório de clientes
    return await repository.getCustomers(type: 'aluno');
  }
}
