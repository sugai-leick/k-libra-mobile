import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';

abstract class ICustomersRepository {
  Future<Either<Failure, List<CustomerEntity>>> getCustomers({String? type, String? pending, String? filter});
  Future<Either<Failure, void>> createCustomer(CustomerEntity customer);
  Future<Either<Failure, void>> updateCustomer(CustomerEntity customer);
  Future<Either<Failure, void>> deleteCustomer(String id);
  Future<Either<Failure, CustomerEntity>> getCustomerById(String id);
  
  // Realtime total count
  Stream<Either<Failure, int>> getTotalCustomers();
}
