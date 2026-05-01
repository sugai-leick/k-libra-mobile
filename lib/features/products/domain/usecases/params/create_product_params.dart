import 'package:flutter_app/features/products/domain/usecases/params/create_product_variant_params.dart';
import 'package:flutter_app/features/products/presentation/widgets/dtos/product_dto.dart';

class CreateProductParams {
  final String nome;
  final String? descricao;
  final ProductType tipo;
  final String? ncm;
  final String? origemFiscal;
  final String? cfopPadrao;
  final bool? requiresInvoice;
  final List<CreateProductVariantParams>? variants;

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

  factory CreateProductParams.fromDto(ProductDto dto) {
    return CreateProductParams(
      nome: dto.nome,
      descricao: dto.descricao,
      tipo: dto.tipo,
      ncm: dto.ncm,
      origemFiscal: dto.origemFiscal,
      cfopPadrao: dto.cfopPadrao,
      requiresInvoice: dto.requiresInvoice,
      variants: dto.variants?.map((v) => CreateProductVariantParams(
        nome: v.nome,
        codigo: v.codigo,
        atributo: v.atributo ?? '',
        cor: v.cor,
      )).toList(),
    );
  }
}
