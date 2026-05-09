import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/entity/product_variant.dart';
import 'package:flutter_app/features/products/domain/usecases/params/create_product_params.dart';

abstract class IProductsRepo {
  Future<Either<Failure, List<Product>>> getProducts(NoParams params);
  Future<Either<Failure, Success>> addProduct(CreateProductParams params);
  Future<Either<Failure, List<ProductVariant>>> getVariants(NoParams params);
  Future<Either<Failure, Unit>> getProductBundle();
  Future<Either<Failure, Unit>> deleteProduct();
  Future<Either<Failure, Unit>> updateProduct(String id);
}
