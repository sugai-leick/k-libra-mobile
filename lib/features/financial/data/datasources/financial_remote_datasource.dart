import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/features/financial/data/models/financial_models.dart';

abstract class IFinancialRemoteDataSource {
  Future<CashFlowModel> getCashFlow();
  Future<List<FinancialTransactionModel>> getTransactions();
  Future<void> addTransaction(FinancialTransactionModel transaction);
}

class FinancialRemoteDataSource implements IFinancialRemoteDataSource {
  final HttpService _httpService;

  FinancialRemoteDataSource(this._httpService);

  @override
  Future<CashFlowModel> getCashFlow() async {
    try {
      final response = await _httpService.get('/financial-transactions/cash-flow');
      if (response.statusCode == 200) {
        return CashFlowModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw AppException(message: 'Falha ao buscar fluxo de caixa.');
      }
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<FinancialTransactionModel>> getTransactions() async {
    try {
      final response = await _httpService.get('/financial-transactions');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => FinancialTransactionModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw AppException(message: 'Falha ao buscar transações.');
      }
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<void> addTransaction(FinancialTransactionModel transaction) async {
    try {
      final response = await _httpService.post('/financial-transactions', data: transaction.toJson());
      if (response.statusCode != 201) {
        throw AppException(message: 'Falha ao registrar transação.');
      }
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }
}
