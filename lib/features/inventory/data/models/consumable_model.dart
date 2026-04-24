import 'package:flutter_app/features/inventory/domain/entities/inventory_consumable_entity.dart';

class ConsumableModel extends InventoryConsumableEntity {
  const ConsumableModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.status,
    super.updatedAt,
  });

  factory ConsumableModel.fromJson(Map<String, dynamic> json) {
    int parsedQty = 0;
    if (json['quantidade_atual'] != null) {
      if (json['quantidade_atual'] is int) {
        parsedQty = json['quantidade_atual'];
      } else {
        parsedQty = int.tryParse(json['quantidade_atual'].toString()) ?? 0;
      }
    } else if (json['quantity'] != null) {
      if (json['quantity'] is int) {
        parsedQty = json['quantity'];
      } else {
        parsedQty = int.tryParse(json['quantity'].toString()) ?? 0;
      }
    }

    String extractProductName(dynamic prods) {
      if (prods == null) return '';
      if (prods is List && prods.isNotEmpty) return prods[0]['nome']?.toString() ?? '';
      if (prods is Map) return prods['nome']?.toString() ?? '';
      return '';
    }

    final pName = extractProductName(json['products']);
    final fallbackName = json['name'] ?? json['nome'] ?? 'Item N/A';

    final idFallback = json['id']?.toString() ?? 
                       json['_id']?.toString() ?? 
                       (json['product_sk'] != null ? '${json['product_sk']}-${json['variant_id'] ?? 'default'}' : '');

    return ConsumableModel(
      id: idFallback,
      name: pName.isNotEmpty ? pName : fallbackName,
      quantity: parsedQty,
      status: json['status']?.toString() ?? 'Disponível',
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
