import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/features/financial/data/datasources/financial_remote_datasource.dart';
import 'package:flutter_app/features/financial/data/models/financial_models.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';

class FinancialRepositoryImpl implements IFinancialRepository {
  final IFinancialRemoteDataSource remoteDataSource;

  FinancialRepositoryImpl(this.remoteDataSource);

  @override
  ReturnFuture<CashFlow> getCashFlow() async {
    try {
      final cashFlowModel = await remoteDataSource.getCashFlow();
      return Right(cashFlowModel);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  ReturnFuture<List<FinancialTransaction>> getTransactions() async {
    try {
      final transactions = await remoteDataSource.getTransactions();
      return Right(transactions);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  ReturnFuture<Unit> addTransaction(FinancialTransaction transaction) async {
    try {
      final model = FinancialTransactionModel(
        id: transaction.id,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        description: transaction.description,
        date: transaction.date,
      );
      await remoteDataSource.addTransaction(model);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  ReturnFuture<DreEntity> getStrategicData({
    required String from,
    required String to,
    required String regime,
  }) async {
    try {
      final dreModel = await remoteDataSource.getStrategicData(
        from: from,
        to: to,
        regime: regime,
      );
      return Right(dreModel);
    } on AppException catch (e) {
      return Left(ServerFailure(msg: e.message));
    } catch (e) {
      return Left(ServerFailure(msg: 'Erro inesperado: ${e.toString()}'));
    }
  }
}

// Reutilizando o ServerFailure do domínio de Clientes ou Core
class ServerFailure extends Failure {
  ServerFailure({required super.msg});
}
