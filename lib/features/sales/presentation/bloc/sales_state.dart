part of 'sales_bloc.dart';

final class SalesState {
  final bool isLoading;
  final List<SaleEntity>? list;
  final String? error;

  SalesState({
    this.isLoading = false,
    this.list,
    this.error,
  });

  SalesState copyWith({
    bool? isLoading,
    List<SaleEntity>? list,
    String? error,
  }) {
    return SalesState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      error: error ?? this.error,
    );
  }
}
