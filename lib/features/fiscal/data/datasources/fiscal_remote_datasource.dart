import 'package:flutter_app/core/failures/app_exception.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/features/fiscal/data/models/invoice_model.dart';

abstract class IFiscalRemoteDataSource {
  Future<List<InvoiceModel>> getInvoices();
  Future<void> createInvoice(InvoiceModel invoice);
}

class FiscalRemoteDataSource implements IFiscalRemoteDataSource {
  final HttpService _httpService;

  FiscalRemoteDataSource(this._httpService);

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final response = await _httpService.get('/fiscal/invoices');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => InvoiceModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw AppException(message: 'Falha ao buscar notas fiscais.');
      }
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<void> createInvoice(InvoiceModel invoice) async {
    try {
      final response = await _httpService.post('/fiscal/invoices', data: invoice.toJson());
      if (response.statusCode != 201) {
        throw AppException(message: 'Falha ao emitir nota fiscal.');
      }
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }
}
