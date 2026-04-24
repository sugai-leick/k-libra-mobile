import 'package:flutter_app/features/inventory/domain/entities/inventory_hardware_entity.dart';

class HardwareModel extends InventoryHardwareEntity {
  const HardwareModel({
    required super.id,
    required super.name,
    required super.serialNumber,
    required super.status,
    super.createdAt,
    super.updatedAt,
    super.observacoes,
    super.hasIssue,
  });

  factory HardwareModel.fromJson(Map<String, dynamic> json) {
    String extractProductName(dynamic prods) {
      if (prods == null) return '';
      if (prods is List && prods.isNotEmpty) return prods[0]['nome']?.toString() ?? '';
      if (prods is Map) return prods['nome']?.toString() ?? '';
      return '';
    }

    final pName = extractProductName(json['products']);
    final fallbackName = json['name'] ?? json['nome'] ?? 'Equipamento N/A';

    return HardwareModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: pName.isNotEmpty ? pName : fallbackName,
      serialNumber: json['serial_number']?.toString() ?? json['serialNumber']?.toString() ?? json['serial']?.toString() ?? 'Sem Serial',
      status: json['status']?.toString() ?? 'Disponível',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      observacoes: json['observacoes']?.toString(),
      hasIssue: json['has_issue'] == true,
    );
  }
}
