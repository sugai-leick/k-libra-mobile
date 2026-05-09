class InventoryTransactionDto {
  final int productSk;
  final String productId;
  final String? variantId;
  final int quantity;
  final String type; // 'entrada' or 'saida'
  final String referenceType;
  final String? referenceId;

  InventoryTransactionDto({
    required this.productSk,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.type,
    this.referenceType = 'manual',
    this.referenceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      if (variantId != null && variantId!.isNotEmpty) 'variant_id': variantId,
      'quantidade': quantity,
      'tipo': type,
      'reference_type': referenceType,
    };
  }
}
