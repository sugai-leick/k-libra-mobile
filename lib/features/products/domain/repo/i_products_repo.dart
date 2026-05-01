import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';

abstract class IProductsRepo {
  Future<Either<Failure, List<Product>>> getProducts(NoParams params);
  Future<Either<Failure, Unit>> addProduct();
  Future<Either<Failure, Unit>> getProductVariant();
  Future<Either<Failure, Unit>> getProductBundle();
  Future<Either<Failure, Unit>> deleteProduct();
  Future<Either<Failure, Unit>> updateProduct(String id);
}
