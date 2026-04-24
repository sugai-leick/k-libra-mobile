import 'dart:async';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/features/sales/data/models/sale_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ISalesRemoteDataSource {
  Future<List<SaleModel>> getSales();
  Future<void> createSale(SaleModel sale);
  Stream<int> watchTotalSales();
}

class SalesRemoteDataSource implements ISalesRemoteDataSource {
  final HttpService httpService;
  final SupabaseClient supabase;

  SalesRemoteDataSource({required this.httpService, required this.supabase});

  @override
  Future<List<SaleModel>> getSales() async {
    // Implementação de listagem existente ou mock
    return [];
  }

  @override
  Future<void> createSale(SaleModel sale) async {
    // Aqui você vai implementar a chamada para a sua API NestJS
    // Ex: await httpService.post('/sales', data: sale.toJson());
  }

  @override
  Stream<int> watchTotalSales() {
    final query = supabase
        .from('sales')
        .stream(primaryKey: ['id'])
        .map((total) => total.length);

    return query;
  }
}
