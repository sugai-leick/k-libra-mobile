import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';

abstract class IProductsRepo {
  Future<Either<Failure, List<Product>>> getProducts(NoParams params);
  Future<Either<Failure, Unit>> addProduct();
  Future<Either<Failure, Unit>> getProductVariant();
  Future<Either<Failure, Unit>> getProductBundle();
  Future<Either<Failure, Unit>> deleteProduct();
  Future<Either<Failure, Unit>> updateProduct(String id);
}

enum ProductType { hardware, consumivel }

enum ProductVariantAtributo { low, medium, high }

class ProductVariant {
  final String nome;
  final int codigo;
  final ProductVariantAtributo atributo;
  final String cor;
  ProductVariant({
    required this.atributo,
    required this.codigo,
    required this.nome,
    required this.cor,
  });
}

class ProductDto {
  final String nome;
  final String descricao;
  final ProductType productType;
  final String ncm;
  final String origem_fiscal;
  final String cfop_padrao;
  final bool requires_invoice;
  final List<ProductVariant> variant;
  ProductDto({
    required this.cfop_padrao,
    required this.descricao,
    required this.ncm,
    required this.nome,
    required this.origem_fiscal,
    required this.productType,
    required this.requires_invoice,
    required this.variant,
  });
}

///
//{
//   "nome": "iPhone 15 Pro Display",
//   "descricao": "High quality replacement display",
//   "tipo": "hardware",
//   "ncm": "85177010",
//   "origem_fiscal": "0",
//   "cfop_padrao": "5102",
//   "requires_invoice": true,
//   "variants": [
//     {
//       "nome": "Azul",
//       "codigo": "AZ-01",
//       "atributo": "Cor",
//       "cor": "#0000FF"
//     }
//   ]
// }
///
