import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';

abstract class ISalesRepository {
  Future<Either<Failure, List<SaleEntity>>> getSales();
  Future<Either<Failure, void>> createSale(SaleEntity sale);
  Stream<Either<Failure, int>> watchTotalSales();
}
