import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';

class SaleModel extends SaleEntity {
  const SaleModel({
    super.id,
    required super.requestId,
    required super.customerId,
    required super.saleType,
    super.courseSk,
    super.courseId,
    super.planType,
    super.quantidade,
    super.valor,
    super.desconto,
    super.frete,
    super.items,
    super.shippingAddress,
    super.status,
    super.createdAt,
  });

  factory SaleModel.fromEntity(SaleEntity entity) {
    return SaleModel(
      id: entity.id,
      requestId: entity.requestId,
      customerId: entity.customerId,
      saleType: entity.saleType,
      courseSk: entity.courseSk,
      courseId: entity.courseId,
      planType: entity.planType,
      quantidade: entity.quantidade,
      valor: entity.valor,
      desconto: entity.desconto,
      frete: entity.frete,
      items: entity.items,
      shippingAddress: entity.shippingAddress,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'customer_id': customerId,
      'sale_type': saleType,
      'course_sk': courseSk,
      'course_id': courseId,
      'plan_type': planType,
      'quantidade': quantidade,
      'valor': valor,
      'desconto': desconto,
      'frete': frete,
      'items': items?.map((i) => SaleItemModel.fromEntity(i).toJson()).toList(),
      'shipping_address': shippingAddress != null 
          ? ShippingAddressModel.fromEntity(shippingAddress!).toJson() 
          : null,
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      requestId: json['request_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      saleType: json['sale_type'] ?? '',
      courseSk: json['course_sk'],
      courseId: json['course_id'],
      planType: json['plan_type'],
      quantidade: json['quantidade'] ?? 1,
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      desconto: (json['desconto'] as num?)?.toDouble(),
      frete: (json['frete'] as num?)?.toDouble(),
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }
}

class SaleItemModel extends SaleItemEntity {
  const SaleItemModel({
    super.productSk,
    super.productId,
    super.variantId,
    required super.quantidade,
    required super.valorUnitario,
    super.isFree,
  });

  factory SaleItemModel.fromEntity(SaleItemEntity entity) {
    return SaleItemModel(
      productSk: entity.productSk,
      productId: entity.productId,
      variantId: entity.variantId,
      quantidade: entity.quantidade,
      valorUnitario: entity.valorUnitario,
      isFree: entity.isFree,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_sk': productSk,
      'product_id': productId,
      'variant_id': variantId,
      'quantidade': quantidade,
      'valor_unitario': valorUnitario,
      'is_free': isFree,
    };
  }
}

class ShippingAddressModel extends ShippingAddressEntity {
  const ShippingAddressModel({
    required super.nome,
    super.telefone,
    required super.cep,
    required super.rua,
    required super.numero,
    super.complemento,
    required super.bairro,
    required super.cidade,
    required super.estado,
    super.pais,
  });

  factory ShippingAddressModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressModel(
      nome: entity.nome,
      telefone: entity.telefone,
      cep: entity.cep,
      rua: entity.rua,
      numero: entity.numero,
      complemento: entity.complemento,
      bairro: entity.bairro,
      cidade: entity.cidade,
      estado: entity.estado,
      pais: entity.pais,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'telefone': telefone,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'pais': pais,
    };
  }
}
