import 'dart:async';
import 'package:flutter_app/core/failures/clients_failure.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/features/clients/data/models/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ICustomersRemoteDataSource {
  Future<List<CustomerModel>> getCustomers({
    String? type,
    String? pending,
    String? filter,
  });
  Future<void> createCustomer(CustomerModel customer);
  Future<void> updateCustomer(CustomerModel customer);
  Future<void> deleteCustomer(String id);
  Future<CustomerModel> getCustomerById(String id);
  Stream<int> getTotalCustomers();
}

class CustomersRemoteDataSource implements ICustomersRemoteDataSource {
  final HttpService _httpService;
  final SupabaseClient _supabase;
  final String _tableName = 'customers';

  CustomersRemoteDataSource({
    required HttpService httpService,
    required SupabaseClient supabase,
  }) : _httpService = httpService,
       _supabase = supabase;

  @override
  Future<List<CustomerModel>> getCustomers({
    String? type,
    String? pending,
    String? filter,
  }) async {
    final response = await _httpService.get(
      '/customers',
      queryParameters: {
        if (type != null) 'type': type,
        if (pending != null) 'pending': pending,
        if (filter != null) 'filter': filter,
      },
    );
    return (response.data as List)
        .map((json) => CustomerModel.fromJson(json))
        .toList();
  }

  @override
  Future<CustomerModel> getCustomerById(String id) async {
    final response = await _httpService.get('/customers/$id');
    return CustomerModel.fromJson(response.data);
  }

  @override
  Future<void> createCustomer(CustomerModel customer) async {
    await _httpService.post('/customers', data: customer.toJson());
    // Após criar com sucesso, avisamos o nosso próprio stream para atualizar
    //refreshCount();
  }

  @override
  Future<void> updateCustomer(CustomerModel customer) async {
    await _httpService.put(
      '/customers/${customer.id}',
      data: customer.toJson(),
    );
  }

  @override
  Future<void> deleteCustomer(String id) async {
    try {
      await _httpService.delete('/customers/$id');
    } catch (e) {
      throw ClientsFailure(
        msg: 'Não foi possível remover o cliente selecionado!',
      );
    }
  }

  @override
  Stream<int> getTotalCustomers() {
    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .map((total) => total.length)
        .handleError((error) {
          if (error is AuthException) {
            throw ClientsFailure(msg: error.message);
          }
          throw ClientsFailure(msg: 'Não foi possível se conectar');
        });
  }
}
