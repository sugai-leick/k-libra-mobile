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
}
