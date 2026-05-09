import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';

abstract class IFinancialRepository {
  Future<Either<Failure, CashFlow>> getCashFlow();
  Future<Either<Failure, List<FinancialTransaction>>> getTransactions();
  Future<Either<Failure, void>> addTransaction(FinancialTransaction transaction);
  Future<Either<Failure, DreEntity>> getStrategicData({
    required String from,
    required String to,
    required String regime,
  });
}
