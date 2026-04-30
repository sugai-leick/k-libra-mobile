import 'package:flutter_app/features/products/domain/usecases/params/create_product_variant_params.dart';

class CreateProductParams {
  final String nome;
  final String descricao;
  final String tipo;
  final String ncm;
  final String origemFiscal;
  final String cfopPadrao;
  final bool requiresInvoice;
  final List<CreateProductVariantParams> variants;

  CreateProductParams({
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.ncm,
    required this.origemFiscal,
    required this.cfopPadrao,
    required this.requiresInvoice,
    required this.variants,
  });
}

