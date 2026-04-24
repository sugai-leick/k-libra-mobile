import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/domain/repositories/inventory_repository.dart';

class AddHardwareUseCase {
  final InventoryRepository repository;

  AddHardwareUseCase(this.repository);

  Future<Either<Failure, void>> call(AddHardwareDto dto) async {
    return await repository.registerHardware(dto);
  }
}
