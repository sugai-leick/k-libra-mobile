class CreateProductVariantParams {
  final String nome;
  final String codigo;
  final String atributo;
  final String? cor;

  CreateProductVariantParams({
    required this.nome,
    required this.codigo,
    required this.atributo,
    this.cor,
  });
}