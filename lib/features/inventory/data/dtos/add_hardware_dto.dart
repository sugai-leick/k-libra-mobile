class AddHardwareDto {
  final int productSk;
  final String productId;
  final String? variantId;
  final String serialNumber;
  final String companyId;

  AddHardwareDto({
    required this.productSk,
    required this.productId,
    this.variantId,
    required this.serialNumber,
    this.companyId = '385e04c1-439b-44a9-a350-a8928a44431c',
  });

  Map<String, dynamic> toJson() {
    return {
      'product_sk': productSk,
      if (variantId != null && variantId!.isNotEmpty) 'variant_id': variantId,
      'serial_number': serialNumber,
      'company_id': companyId,
    };
  }
}
