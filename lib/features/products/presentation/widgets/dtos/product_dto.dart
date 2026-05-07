enum ProductType { hardware, insumo, consumivel }

class ProductDto {
  final String nome;
  final String? descricao;
  final ProductType tipo;
  final String? ncm;
  final String? origemFiscal;
  final String? cfopPadrao;
  final bool? requiresInvoice;
  final List<ProductVariant>? variants;

  ProductDto({
    required this.nome,
    required this.tipo,
    this.descricao,
    this.ncm,
    this.origemFiscal,
    this.cfopPadrao,
    this.requiresInvoice,
    this.variants,
  });
}

class ProductVariant {
  final String nome;
  final String codigo;
  final String? atributo;
  final String? cor;

  ProductVariant({
    required this.nome,
    required this.codigo,
    this.atributo,
    this.cor,
  });
}
