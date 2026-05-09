import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';

class GetCashFlowUseCase implements Usecase<NoParams, CashFlow> {
  final IFinancialRepository repository;

  GetCashFlowUseCase(this.repository);

  @override
  ReturnFuture<CashFlow> call(NoParams params) async {
    return await repository.getCashFlow();
  }
}
