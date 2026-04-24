import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/clients/domain/entities/customer_entity.dart';
import 'package:flutter_app/features/clients/domain/usecases/customers_usecases.dart';
import 'package:flutter/foundation.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsGlobalState> {
  final GetCustomersUseCase getCustomersUseCase;
  final CreateCustomerUseCase createCustomerUseCase;
  final DeleteCustomerUseCase deleteCustomerUseCase;

  ClientsBloc({
    required this.getCustomersUseCase,
    required this.createCustomerUseCase,
    required this.deleteCustomerUseCase,
  }) : super(ClientsGlobalState()) {
    on<FetchClientsListEvent>(_onFetchClientsList);
    on<AddClientEvent>(_onAddClient);
    on<DeleteClientEvent>(_onDeleteClient);
  }

  Future<void> _onFetchClientsList(
    FetchClientsListEvent event,
    Emitter<ClientsGlobalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    final result = await getCustomersUseCase(GetCustomersParams(
      type: event.type,
      pending: event.pending,
      filter: event.filter,
    ));
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.msg)),
      (list) => emit(state.copyWith(isLoading: false, list: list)),
    );
  }

  Future<void> _onAddClient(
    AddClientEvent event,
    Emitter<ClientsGlobalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    final result = await createCustomerUseCase(event.customer);
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.msg)),
      (_) {
        emit(state.copyWith(isLoading: false));
        add(FetchClientsListEvent());
      },
    );
  }

  Future<void> _onDeleteClient(
    DeleteClientEvent event,
    Emitter<ClientsGlobalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    final result = await deleteCustomerUseCase(event.clientId);
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.msg)),
      (_) {
        emit(state.copyWith(isLoading: false));
        add(FetchClientsListEvent());
      },
    );
  }
}
