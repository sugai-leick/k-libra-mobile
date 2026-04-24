import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/sales/domain/repositories/sales_repository.dart';

class TotalSalesUsecase implements StreamUsecase<NoParams, int> {
  final ISalesRepository repository;
  
  TotalSalesUsecase({required this.repository});
  
  @override
  Stream<Either<Failure, int>> call(NoParams params) {
    return repository.watchTotalSales();
  }
}
