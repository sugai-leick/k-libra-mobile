import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/inventory/domain/repositories/inventory_repository.dart';

class FetchInventoryUseCase {
  final InventoryRepository repository;

  FetchInventoryUseCase(this.repository);

  Future<Either<Failure, InventoryCollection>> call() async {
    return await repository.fetchInventory();
  }
}
