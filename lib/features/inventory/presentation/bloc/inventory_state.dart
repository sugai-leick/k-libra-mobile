import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_consumable_entity.dart';
import 'package:flutter_app/features/inventory/domain/entities/inventory_hardware_entity.dart';

class InventoryState extends Equatable {
  final bool isLoading;
  final List<InventoryHardwareEntity>? hardwareList;
  final List<InventoryConsumableEntity>? consumablesList;
  final String? error;
  final bool actionSuccess;

  const InventoryState({
    this.isLoading = false,
    this.hardwareList,
    this.consumablesList,
    this.error,
    this.actionSuccess = false,
  });

  InventoryState copyWith({
    bool? isLoading,
    List<InventoryHardwareEntity>? hardwareList,
    List<InventoryConsumableEntity>? consumablesList,
    String? error,
    bool clearError = false,
    bool actionSuccess = false,
  }) {
    return InventoryState(
      isLoading: isLoading ?? this.isLoading,
      hardwareList: hardwareList ?? this.hardwareList,
      consumablesList: consumablesList ?? this.consumablesList,
      error: clearError ? null : (error ?? this.error),
      actionSuccess: actionSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, hardwareList, consumablesList, error, actionSuccess];
}
