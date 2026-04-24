import 'package:dio/dio.dart';

class ViacepService {
  final Dio _dio;

  ViacepService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>?> fetchCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanCep.length != 8) return null;

    try {
      final response = await _dio.get(
        'https://viacep.com.br/ws/$cleanCep/json/',
      );
      if (response.statusCode == 200) {
        if (response.data['erro'] == true) {
          return null;
        }
        return response.data;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
