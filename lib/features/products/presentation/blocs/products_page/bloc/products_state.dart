part of 'products_bloc.dart';

enum ProductsStatus { initial, loading, success, error }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<Product> products;
  final String? message;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.message,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    String? message,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, products, message];
}
