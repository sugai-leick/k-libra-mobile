import 'package:equatable/equatable.dart';

class ProductVariant extends Equatable {
  final String id;
  final int productSk;
  final String nome;
  final String? cor;
  final String? atributo;

  const ProductVariant({
    required this.id,
    required this.productSk,
    required this.nome,
    this.cor,
    this.atributo,
  });

  @override
  List<Object?> get props => [id, productSk, nome, cor, atributo];
}
