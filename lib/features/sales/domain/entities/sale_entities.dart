import 'package:equatable/equatable.dart';

class SaleEntity extends Equatable {
  final String id;
  final double totalAmount;
  final String status; // 'PENDING', 'COMPLETED', 'CANCELLED'
  final DateTime createdAt;
  final List<SaleItemEntity>? items;

  const SaleEntity({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.items,
  });

  @override
  List<Object?> get props => [id, totalAmount, status, createdAt, items];
}

class SaleItemEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const SaleItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [id, productId, productName, quantity, unitPrice];
}
