import 'package:flutter_app/features/products/domain/usecases/params/create_product_params.dart';

class CreateProductModel extends CreateProductParams {
  CreateProductModel({
    required super.nome,
    required super.descricao,
    required super.tipo,
    required super.ncm,
    required super.origemFiscal,
    required super.cfopPadrao,
    required super.requiresInvoice,
    required super.variants,
  });

  factory CreateProductModel.fromParams(CreateProductParams params) {
    return CreateProductModel(
      nome: params.nome,
      descricao: params.descricao,
      tipo: params.tipo,
      ncm: params.ncm,
      origemFiscal: params.origemFiscal,
      cfopPadrao: params.cfopPadrao,
      requiresInvoice: params.requiresInvoice,
      variants: params.variants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo.name, // Extrai a string do enum
      'ncm': ncm,
      'origem_fiscal': origemFiscal,
      'cfop_padrao': cfopPadrao,
      'requires_invoice': requiresInvoice,
      if (variants != null)
        'variants': variants!.map((v) => {
          'nome': v.nome,
          'codigo': v.codigo,
          'atributo': v.atributo,
          'cor': v.cor,
        }).toList(),
    };
  }
}
