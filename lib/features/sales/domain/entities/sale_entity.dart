import 'package:equatable/equatable.dart';

class SaleEntity extends Equatable {
  final String? id; // Adicionado para suportar a listagem
  final String requestId;
  final String customerId;
  final String saleType;
  final int? courseSk;
  final String? courseId;
  final String? planType;
  final int quantidade;
  final double valor;
  final double? desconto;
  final double? frete;
  final List<SaleItemEntity>? items;
  final ShippingAddressEntity? shippingAddress;
  final String? status; // Adicionado para suportar a listagem
  final DateTime? createdAt; // Adicionado para suportar a listagem

  const SaleEntity({
    this.id,
    required this.requestId,
    required this.customerId,
    required this.saleType,
    this.courseSk,
    this.courseId,
    this.planType,
    this.quantidade = 1,
    this.valor = 0.0,
    this.desconto = 0.0,
    this.frete = 0.0,
    this.items,
    this.shippingAddress,
    this.status,
    this.createdAt,
  });

  // Getter de conveniência para não quebrar a UI que espera totalAmount
  double get totalAmount => valor;

  SaleEntity copyWith({
    String? id,
    String? requestId,
    String? customerId,
    String? saleType,
    int? courseSk,
    String? courseId,
    String? planType,
    int? quantidade,
    double? valor,
    double? desconto,
    double? frete,
    List<SaleItemEntity>? items,
    ShippingAddressEntity? shippingAddress,
    String? status,
    DateTime? createdAt,
  }) {
    return SaleEntity(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      customerId: customerId ?? this.customerId,
      saleType: saleType ?? this.saleType,
      courseSk: courseSk ?? this.courseSk,
      courseId: courseId ?? this.courseId,
      planType: planType ?? this.planType,
      quantidade: quantidade ?? this.quantidade,
      valor: valor ?? this.valor,
      desconto: desconto ?? this.desconto,
      frete: frete ?? this.frete,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, requestId, customerId, saleType, valor];
}

class SaleItemEntity extends Equatable {
  final int? productSk;
  final String? productId;
  final String? variantId;
  final int quantidade;
  final double valorUnitario;
  final bool isFree;

  const SaleItemEntity({
    this.productSk,
    this.productId,
    this.variantId,
    required this.quantidade,
    required this.valorUnitario,
    this.isFree = false,
  });

  @override
  List<Object?> get props => [productSk, productId, variantId, quantidade, valorUnitario];
}

class ShippingAddressEntity extends Equatable {
  final String nome;
  final String? telefone;
  final String cep;
  final String rua;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String? pais;

  const ShippingAddressEntity({
    required this.nome,
    this.telefone,
    required this.cep,
    required this.rua,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.pais,
  });

  ShippingAddressEntity copyWith({
    String? nome,
    String? telefone,
    String? cep,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? estado,
    String? pais,
  }) {
    return ShippingAddressEntity(
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      pais: pais ?? this.pais,
    );
  }

  @override
  List<Object?> get props => [nome, cep, rua, numero, cidade, estado];
}
