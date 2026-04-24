import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:flutter_app/features/inventory/data/models/consumable_model.dart';
import 'package:flutter_app/features/inventory/data/models/hardware_model.dart';
import 'package:flutter_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDatasource remoteDatasource;

  InventoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, InventoryCollection>> fetchInventory() async {
    try {
      final response = await remoteDatasource.fetchInventory();
      
      final hwModels = response['hardware'] as List<HardwareModel>? ?? [];
      final csModels = response['consumables'] as List<ConsumableModel>? ?? [];

      return Right(InventoryCollection(
        hardware: hwModels,
        consumables: csModels,
      ));
    } catch (e) {
      return Left(Failure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerHardware(AddHardwareDto dto) async {
    try {
      await remoteDatasource.registerHardware(dto);
      return const Right(null);
    } catch (e) {
      return Left(Failure(msg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerTransaction(InventoryTransactionDto dto) async {
    try {
      await remoteDatasource.registerTransaction(dto);
      return const Right(null);
    } catch (e) {
      return Left(Failure(msg: e.toString()));
    }
  }
}
