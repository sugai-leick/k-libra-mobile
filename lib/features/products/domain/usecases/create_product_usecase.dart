import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/contracts/success.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/products/domain/repo/i_products_repo.dart';
import 'package:flutter_app/features/products/domain/usecases/params/create_product_params.dart';

class CreateProductUsecase implements Usecase<CreateProductParams, Success> {
  final IProductsRepo _repo;
  CreateProductUsecase({required repo}) : _repo = repo;
  @override
  Future<Either<Failure, Success>> call(params) async {
    final result = await _repo.addProduct(params);
    return result;
  }
}
