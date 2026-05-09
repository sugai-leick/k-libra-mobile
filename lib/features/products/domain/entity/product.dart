import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int productSk;
  final String productId;
  final String companyId;
  final String nome;
  final String descricao;
  final String tipo;
  final String ncm;
  final String origemFiscal;
  final String cfopPadrao;
  final bool requiresInvoice;
  final DateTime effectiveDate;
  final DateTime endDate;
  final bool isCurrent;
  final DateTime createdAt;

  Product({
    required this.productSk,
    required this.productId,
    required this.companyId,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.ncm,
    required this.origemFiscal,
    required this.cfopPadrao,
    required this.requiresInvoice,
    required this.effectiveDate,
    required this.endDate,
    required this.isCurrent,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [productId, productSk];
}