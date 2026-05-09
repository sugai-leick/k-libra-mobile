import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';

class GetTransactionsUseCase implements Usecase<NoParams, List<FinancialTransaction>> {
  final IFinancialRepository repository;

  GetTransactionsUseCase(this.repository);

  @override
  ReturnFuture<List<FinancialTransaction>> call(NoParams params) async {
    return await repository.getTransactions();
  }
}
