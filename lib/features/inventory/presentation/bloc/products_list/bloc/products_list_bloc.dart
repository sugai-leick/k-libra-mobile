import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/inventory/domain/usecases/fetch_products_usecase.dart';
import 'package:flutter_app/features/products/domain/entity/product.dart';
import 'package:flutter_app/features/products/domain/entity/product_variant.dart';
import 'package:flutter_app/features/products/domain/usecases/get_variants_usecase.dart';

part 'products_list_event.dart';
part 'products_list_state.dart';

class ProductsListBloc extends Bloc<ProductsListEvent, ProductsListState> {
  final FetchProductsUsecase fetchProductsUsecase;
  final GetVariantsUsecase getVariantsUsecase;

  ProductsListBloc({
    required this.fetchProductsUsecase,
    required this.getVariantsUsecase,
  }) : super(ProductsListInitial()) {
    on<ProductsListRequested>(_productsListRequested);
  }
  Future<void> _productsListRequested(
    ProductsListEvent event,
    Emitter<ProductsListState> emit,
  ) async {
    emit(ProductsListLoading());

    final results = await Future.wait([
      fetchProductsUsecase(NoParams()),
      getVariantsUsecase(NoParams()),
    ]);

    final productsResult = results[0];
    final variantsResult = results[1];

    productsResult.fold(
      (failure) => emit(ProductsListError(errorMsg: failure.msg)),
      (productList) {
        variantsResult.fold(
          (failure) => emit(ProductsListError(errorMsg: failure.msg)),
          (variantList) => emit(ProductsListLoaded(
            productList: productList as List<Product>,
            variantList: variantList as List<ProductVariant>,
          )),
        );
      },
    );
  }
}
