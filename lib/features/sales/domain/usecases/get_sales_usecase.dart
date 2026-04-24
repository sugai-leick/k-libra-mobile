import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';
import 'package:flutter_app/features/sales/domain/repositories/sales_repository.dart';

class GetSalesUsecase implements Usecase<NoParams, List<SaleEntity>> {
  final ISalesRepository repository;

  GetSalesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SaleEntity>>> call(NoParams params) async {
    return await repository.getSales();
  }
}
