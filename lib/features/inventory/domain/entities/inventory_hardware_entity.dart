import 'package:equatable/equatable.dart';

class InventoryHardwareEntity extends Equatable {
  final String id;
  final String name;
  final String serialNumber;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final String? observacoes;
  final bool hasIssue;

  const InventoryHardwareEntity({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.observacoes,
    this.hasIssue = false,
  });

  @override
  List<Object?> get props => [id, name, serialNumber, status, createdAt, updatedAt, observacoes, hasIssue];
}
