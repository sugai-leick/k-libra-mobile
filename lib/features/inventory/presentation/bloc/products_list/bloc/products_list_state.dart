part of 'products_list_bloc.dart';

sealed class ProductsListState extends Equatable {
  const ProductsListState();

  @override
  List<Object> get props => [];
}

final class ProductsListInitial extends ProductsListState {}

final class ProductsListLoading extends ProductsListState {}

final class ProductsListError extends ProductsListState {
  final String errorMsg;
  const ProductsListError({required this.errorMsg});
}

final class ProductsListLoaded extends ProductsListState {
  final List<Product> productList;
  final List<ProductVariant> variantList;
  const ProductsListLoaded({
    required this.productList,
    this.variantList = const [],
  });

  @override
  List<Object> get props => [productList, variantList];
}
