import 'package:equatable/equatable.dart';

class InventoryConsumableEntity extends Equatable {
  final String id;
  final String name;
  final int quantity;
  final String status;
  final String? updatedAt;

  const InventoryConsumableEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.status,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, quantity, status, updatedAt];
}
