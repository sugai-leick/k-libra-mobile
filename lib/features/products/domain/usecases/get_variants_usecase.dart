import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/products/domain/entity/product_variant.dart';
import 'package:flutter_app/features/products/domain/repo/i_products_repo.dart';
import 'package:flutter_app/core/typedefs/return_future.dart';

class GetVariantsUsecase implements Usecase<NoParams, List<ProductVariant>> {
  final IProductsRepo _repo;
  GetVariantsUsecase({required repo}) : _repo = repo;

  @override
  ReturnFuture<List<ProductVariant>> call(NoParams params) async {
    return await _repo.getVariants(params);
  }
}
