import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/inventory/domain/usecases/fetch_inventory_usecase.dart';
import 'package:flutter_app/features/inventory/domain/usecases/add_hardware_usecase.dart';
import 'package:flutter_app/features/inventory/domain/usecases/inventory_transaction_usecase.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final FetchInventoryUseCase fetchInventoryUseCase;
  final AddHardwareUseCase addHardwareUseCase;
  final InventoryTransactionUseCase inventoryTransactionUseCase;

  InventoryBloc({
    required this.fetchInventoryUseCase,
    required this.addHardwareUseCase,
    required this.inventoryTransactionUseCase,
  }) : super(const InventoryState()) {
    on<FetchInventoryListEvent>(_onFetchInventory);
    on<AddHardwareEvent>(_onAddHardware);
    on<RegisterTransactionEvent>(_onRegisterTransaction);
  }

  Future<void> _onFetchInventory(FetchInventoryListEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await fetchInventoryUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.msg,
        ));
      },
      (collection) {
        emit(state.copyWith(
          isLoading: false,
          hardwareList: collection.hardware,
          consumablesList: collection.consumables,
        ));
      },
    );
  }

  Future<void> _onAddHardware(AddHardwareEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await addHardwareUseCase(event.dto);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.msg,
        ));
      },
      (_) {
        // Automatically fetch inventory list again on success!
        emit(state.copyWith(isLoading: false, actionSuccess: true));
        add(FetchInventoryListEvent());
      },
    );
  }

  Future<void> _onRegisterTransaction(RegisterTransactionEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await inventoryTransactionUseCase(event.dto);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: failure.msg,
        ));
      },
      (_) {
        emit(state.copyWith(isLoading: false, actionSuccess: true));
        add(FetchInventoryListEvent());
      },
    );
  }
}
