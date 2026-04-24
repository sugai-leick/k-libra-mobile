import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/repositories/customers_repository.dart';

class GetCustomersParams {
  final String? type;
  final String? pending;
  final String? filter;
  GetCustomersParams({this.type, this.pending, this.filter});
}

class GetCustomersUseCase implements Usecase<GetCustomersParams, List<CustomerEntity>> {
  final ICustomersRepository repository;

  GetCustomersUseCase(this.repository);

  @override
  Future<Either<Failure, List<CustomerEntity>>> call(GetCustomersParams params) async {
    return await repository.getCustomers(
      type: params.type,
      pending: params.pending,
      filter: params.filter,
    );
  }
}

class CreateCustomerUseCase implements Usecase<CustomerEntity, void> {
  final ICustomersRepository repository;

  CreateCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CustomerEntity customer) async {
    return await repository.createCustomer(customer);
  }
}

class UpdateCustomerUseCase implements Usecase<CustomerEntity, void> {
  final ICustomersRepository repository;

  UpdateCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CustomerEntity customer) async {
    return await repository.updateCustomer(customer);
  }
}

class DeleteCustomerUseCase implements Usecase<String, void> {
  final ICustomersRepository repository;

  DeleteCustomerUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteCustomer(id);
  }
}

class GetCustomerByIdUseCase implements Usecase<String, CustomerEntity> {
  final ICustomersRepository repository;

  GetCustomerByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CustomerEntity>> call(String id) async {
    return await repository.getCustomerById(id);
  }
}
