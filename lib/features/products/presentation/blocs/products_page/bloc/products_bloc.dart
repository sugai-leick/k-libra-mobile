import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/usecases/create_product_usecase.dart';
import 'package:flutter_app/features/products/domain/usecases/params/create_product_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/products/presentation/widgets/dtos/product_dto.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final CreateProductUsecase _createProduct;

  ProductsBloc({
    required CreateProductUsecase createProduct,
  })  : _createProduct = createProduct,
        super(const ProductsState()) {
    on<NewProductSubmitted>(_newProductSubmitted);
  }

  Future<void> _newProductSubmitted(
    NewProductSubmitted event,
    Emitter<ProductsState> emit,
  ) async {
    // Emite o estado de loading preservando a lista atual de produtos!
    emit(state.copyWith(status: ProductsStatus.loading));
    
    final params = CreateProductParams.fromDto(event.product);
    final result = await _createProduct(params);
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.error, 
        message: failure.msg,
      )),
      (success) => emit(state.copyWith(
        status: ProductsStatus.success, 
        message: success.msg,
      )),
    );
  }
}
