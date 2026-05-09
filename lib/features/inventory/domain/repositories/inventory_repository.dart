import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_consumable_entity.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_hardware_entity.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';

class InventoryCollection {
  final List<InventoryHardwareEntity> hardware;
  final List<InventoryConsumableEntity> consumables;

  const InventoryCollection({
    required this.hardware,
    required this.consumables,
  });
}

abstract class InventoryRepository {
  Future<Either<Failure, InventoryCollection>> fetchInventory();
  Future<Either<Failure, void>> registerHardware(AddHardwareDto dto);
  Future<Either<Failure, void>> registerTransaction(InventoryTransactionDto dto);
  
}
