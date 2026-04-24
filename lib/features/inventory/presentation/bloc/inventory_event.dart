import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/inventory/data/dtos/add_hardware_dto.dart';
import 'package:flutter_app/features/inventory/data/dtos/inventory_transaction_dto.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchInventoryListEvent extends InventoryEvent {}
class AddHardwareEvent extends InventoryEvent {
  final AddHardwareDto dto;
  const AddHardwareEvent(this.dto);
  @override
  List<Object?> get props => [dto];
}
class RegisterTransactionEvent extends InventoryEvent {
  final InventoryTransactionDto dto;
  const RegisterTransactionEvent(this.dto);
  @override
  List<Object?> get props => [dto];
}
