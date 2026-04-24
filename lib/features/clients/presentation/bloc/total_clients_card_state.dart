part of 'total_clients_card_bloc.dart';

final class TotalClientsCardState {
  final bool isLoading;
  final String? error;
  final int? totalCount;

  TotalClientsCardState({
    this.isLoading = false,
    this.error,
    this.totalCount,
  });

  TotalClientsCardState copyWith({
    bool? isLoading,
    String? error,
    int? totalCount,
  }) {
    return TotalClientsCardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
