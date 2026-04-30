import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/repo/i_products_repo.dart';

class GetProductsUsecase implements Usecase<NoParams, List<Product>> {
  final IProductsRepo _repo;
  GetProductsUsecase({required repo}) : _repo = repo;
  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) async {
    final result = await _repo.getProducts(params);
    return result;
  }
}
