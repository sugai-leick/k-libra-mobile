import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/repo/i_products_repo.dart';

class FetchProductsUsecase implements Usecase<NoParams, List<Product>> {
  final IProductsRepo _repo;
  FetchProductsUsecase({required repo}) : _repo = repo;
  @override
  ReturnFuture<List<Product>> call(NoParams params) async {
    final result = await _repo.getProducts(params);
    return result;
  }
}
