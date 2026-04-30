import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/products/data/source/remote/products_source.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/repo/i_products_repo.dart';

class ProductsRepo implements IProductsRepo {
  final IProductsSource _source;
  ProductsRepo({required source}) : _source = source;
  @override
  Future<Either<Failure, Unit>> addProduct() {
    // TODO: implement addProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct() {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> getProductBundle() {
    // TODO: implement getProductBundle
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> getProductVariant() {
    // TODO: implement getProductVariant
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts(NoParams params) async {
    try {
      final result = await _source.getProducts(params);
      
    } catch (e) {
      //
    }
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(String id) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }
}
