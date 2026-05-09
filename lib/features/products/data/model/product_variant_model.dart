import 'package:flutter_app/features/products/domain/entity/product_variant.dart';

class ProductVariantModel extends ProductVariant {
  const ProductVariantModel({
    required super.id,
    required super.productSk,
    required super.nome,
    super.cor,
    super.atributo,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? '',
      productSk: json['product_sk'] ?? 0,
      nome: json['nome'] ?? '',
      cor: json['cor'],
      atributo: json['atributo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_sk': productSk,
      'nome': nome,
      'cor': cor,
      'atributo': atributo,
    };
  }
}
