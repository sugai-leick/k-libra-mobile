import 'package:flutter/foundation.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/products/data/model/create_product_model.dart';
import 'package:flutter_app/features/products/data/model/product_model.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';

abstract class IProductsSource {
  ///retorna uma lista de [Produtos]
  Future<List<ProductModel>> getProducts(NoParams params);
  Future<Success> addProduct(CreateProductModel model);
}

class ProductsSource implements IProductsSource {
  final HttpService _httpService;
  ProductsSource({required httpService}) : _httpService = httpService;
  @override
  Future<List<ProductModel>> getProducts(NoParams params) async {
    try {
      final response = await _httpService.get('/products');

      // A resposta (response.data) é uma lista, então precisamos fazer um loop/map
      final List<dynamic> jsonList = response.data;

      final List<ProductModel> list = jsonList.map((json) {
        return ProductModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      debugPrint('Product Source info >>  ${list.length} produtos carregados');
      return list;
    } catch (e) {
      debugPrint('Product Source error >> $e');
      rethrow;
    }
  }

  @override
  Future<Success> addProduct(CreateProductModel model) async {
    try {
      await _httpService.post('/products', data: model.toJson());
      return Success(msg: 'Novo ${model.tipo.name} adicionado com sucesso');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }
}
