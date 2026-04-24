import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';

class GetCashFlowUseCase implements Usecase<NoParams, CashFlow> {
  final IFinancialRepository repository;

  GetCashFlowUseCase(this.repository);

  @override
  Future<Either<Failure, CashFlow>> call(NoParams params) async {
    return await repository.getCashFlow();
  }
}

class GetTransactionsUseCase implements Usecase<NoParams, List<FinancialTransaction>> {
  final IFinancialRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FinancialTransaction>>> call(NoParams params) async {
    return await repository.getTransactions();
  }
}

class AddTransactionUseCase implements Usecase<FinancialTransaction, void> {
  final IFinancialRepository repository;

  AddTransactionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(FinancialTransaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
