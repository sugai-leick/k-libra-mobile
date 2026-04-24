part of 'total_sales_card_bloc.dart';

final class TotalSalesCardState {
  final bool isLoading;
  final String? error;
  final int? totalCount;

  TotalSalesCardState({
    this.isLoading = false,
    this.error,
    this.totalCount,
  });

  TotalSalesCardState copyWith({
    bool? isLoading,
    String? error,
    int? totalCount,
  }) {
    return TotalSalesCardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
