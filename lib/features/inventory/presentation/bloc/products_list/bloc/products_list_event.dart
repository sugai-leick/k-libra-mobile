part of 'products_list_bloc.dart';

sealed class ProductsListEvent extends Equatable {
  const ProductsListEvent();

  @override
  List<Object> get props => [];
}

class ProductsListRequested extends ProductsListEvent {}
