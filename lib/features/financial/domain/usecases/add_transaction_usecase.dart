import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';

class AddTransactionUseCase implements Usecase<FinancialTransaction, void> {
  final IFinancialRepository repository;

  AddTransactionUseCase(this.repository);

  @override
  ReturnFuture<void> call(FinancialTransaction transaction) async {
    return await repository.addTransaction(transaction);
  }
}
