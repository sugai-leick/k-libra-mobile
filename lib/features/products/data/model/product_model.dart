import 'package:flutter_app/features/products/domain/entity/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.productSk,
    required super.productId,
    required super.companyId,
    required super.nome,
    required super.descricao,
    required super.tipo,
    required super.ncm,
    required super.origemFiscal,
    required super.cfopPadrao,
    required super.requiresInvoice,
    required super.effectiveDate,
    required super.endDate,
    required super.isCurrent,
    required super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productSk: json['product_sk'] as int,
      productId: json['product_id'] as String,
      companyId: json['company_id'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      tipo: json['tipo'] as String,
      ncm: json['ncm'] as String,
      origemFiscal: json['origem_fiscal'] as String,
      cfopPadrao: json['cfop_padrao'] as String,
      requiresInvoice: json['requires_invoice'] as bool,
      effectiveDate: DateTime.parse(json['effective_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      isCurrent: json['is_current'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
