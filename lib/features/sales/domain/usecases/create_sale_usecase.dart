import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';
import 'package:flutter_app/features/sales/domain/repositories/sales_repository.dart';

class CreateSaleUseCase {
  final ISalesRepository repository;

  CreateSaleUseCase({required this.repository});

  Future<Either<Failure, void>> call(SaleEntity sale) async {
    return await repository.createSale(sale);
  }
}
