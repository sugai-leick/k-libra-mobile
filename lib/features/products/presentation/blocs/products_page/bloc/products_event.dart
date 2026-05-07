part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class NewProductSubmitted extends ProductsEvent {
  final ProductDto product;

  const NewProductSubmitted(this.product);

  @override
  List<Object> get props => [product];
}

class FetchProductsEvent extends ProductsEvent {}
