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
      productSk: json['product_sk'] as int? ?? 0,
      productId: json['product_id'] as String? ?? '',
      companyId: json['company_id'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      tipo: json['tipo'] as String? ?? '',
      ncm: json['ncm'] as String? ?? '',
      origemFiscal: json['origem_fiscal'] as String? ?? '',
      cfopPadrao: json['cfop_padrao'] as String? ?? '',
      requiresInvoice: json['requires_invoice'] as bool? ?? false,
      effectiveDate: json['effective_date'] != null 
          ? DateTime.parse(json['effective_date'].toString()) 
          : DateTime.now(),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'].toString()) 
          : DateTime.now(),
      isCurrent: json['is_current'] as bool? ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'].toString()) 
          : DateTime.now(),
    );
  }
}
