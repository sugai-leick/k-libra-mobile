import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/clients/data/datasources/customers_remote_datasource.dart';
import 'package:flutter_app/features/clients/data/models/customer_model.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/repositories/customers_repository.dart';

class CustomersRepositoryImpl implements ICustomersRepository {
  final ICustomersRemoteDataSource remoteDataSource;

  CustomersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CustomerEntity>>> getCustomers({String? type, String? pending, String? filter}) async {
    try {
      final customers = await remoteDataSource.getCustomers(type: type, pending: pending, filter: filter);
      return Right(customers);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> createCustomer(CustomerEntity customer) async {
    try {
      final model = CustomerModel(
        nomeCompleto: customer.nomeCompleto,
        email: customer.email,
        telefone: customer.telefone,
        cpf: customer.cpf,
        cnpj: customer.cnpj,
        dataNascimento: customer.dataNascimento,
        instagram: customer.instagram,
        ocupacao: customer.ocupacao,
        observacao: customer.observacao,
        origem: customer.origem,
        partyStatus: customer.partyStatus,
        isCustomer: customer.isCustomer,
        isSupplier: customer.isSupplier,
        status: customer.status,
        enderecoResidencial: customer.enderecoResidencial != null
            ? AddressModel(
                rua: customer.enderecoResidencial!.rua,
                numero: customer.enderecoResidencial!.numero,
                bairro: customer.enderecoResidencial!.bairro,
                cidade: customer.enderecoResidencial!.cidade,
                estado: customer.enderecoResidencial!.estado,
                cep: customer.enderecoResidencial!.cep,
                complemento: customer.enderecoResidencial!.complemento,
              )
            : null,
      );
      await remoteDataSource.createCustomer(model);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(String id) async {
    try {
      await remoteDataSource.deleteCustomer(id);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> getCustomerById(String id) async {
    try {
      final customer = await remoteDataSource.getCustomerById(id);
      return Right(customer);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomer(CustomerEntity customer) async {
    try {
      final model = CustomerModel(
        nomeCompleto: customer.nomeCompleto,
        email: customer.email,
        telefone: customer.telefone,
        cpf: customer.cpf,
        cnpj: customer.cnpj,
        dataNascimento: customer.dataNascimento,
        instagram: customer.instagram,
        ocupacao: customer.ocupacao,
        observacao: customer.observacao,
        origem: customer.origem,
        partyStatus: customer.partyStatus,
        isCustomer: customer.isCustomer,
        isSupplier: customer.isSupplier,
        status: customer.status,
        enderecoResidencial: customer.enderecoResidencial != null
            ? AddressModel(
                rua: customer.enderecoResidencial!.rua,
                numero: customer.enderecoResidencial!.numero,
                bairro: customer.enderecoResidencial!.bairro,
                cidade: customer.enderecoResidencial!.cidade,
                estado: customer.enderecoResidencial!.estado,
                cep: customer.enderecoResidencial!.cep,
                complemento: customer.enderecoResidencial!.complemento,
              )
            : null,
      );
      await remoteDataSource.updateCustomer(model);
      return const Right(null);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, int>> getTotalCustomers() async* {
    try {
      await for (final total in remoteDataSource.getTotalCustomers()) {
        yield Right(total);
      }
    } on Exception catch (e) {
      yield Left(ServerFailure(msg: e.toString()));
    }
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.msg});
}
