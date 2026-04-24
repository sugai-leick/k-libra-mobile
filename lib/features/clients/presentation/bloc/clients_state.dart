part of 'clients_bloc.dart';

final class ClientsGlobalState {
  final bool isLoading;
  final List<CustomerEntity>? list;
  final String? error;

  ClientsGlobalState({
    this.isLoading = false,
    this.list,
    this.error,
  });

  ClientsGlobalState copyWith({
    bool? isLoading,
    List<CustomerEntity>? list,
    String? error,
  }) {
    return ClientsGlobalState(
      isLoading: isLoading ?? this.isLoading,
      list: list ?? this.list,
      error: error ?? this.error,
    );
  }
}
