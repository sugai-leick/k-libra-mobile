import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';
import 'package:flutter_app/features/inventory/domain/repositories/inventory_repository.dart';

class InventoryTransactionUseCase {
  final InventoryRepository repository;

  InventoryTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(InventoryTransactionDto dto) async {
    return await repository.registerTransaction(dto);
  }
}
