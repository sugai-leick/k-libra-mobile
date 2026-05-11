import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';
import 'package:flutter_app/features/financial/domain/entities/financial_entities.dart';

abstract class IFinancialRepository {
  ReturnFuture<CashFlow> getCashFlow();
  ReturnFuture<List<FinancialTransaction>> getTransactions();
  ReturnFuture<Unit> addTransaction(FinancialTransaction transaction);
  ReturnFuture<DreEntity> getStrategicData({
    required String from,
    required String to,
    required String regime,
  });
}
