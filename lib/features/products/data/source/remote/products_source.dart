import 'package:flutter_app/core/services/http_service.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/products/data/model/product_model.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';

abstract class IProductsSource {
  ///retorna uma lista de [Produtos]
  Future<List<ProductModel>> getProducts(NoParams params);
}

class ProductsSource implements IProductsSource {
  final HttpService _httpService;
  ProductsSource({required httpService}) : _httpService = httpService;
  @override
  Future<List<ProductModel>> getProducts(NoParams params) async {
    final result = await _httpService.get('products');
    print(result);
    return [];
  }
}
