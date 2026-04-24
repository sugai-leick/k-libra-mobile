import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/sales/domain/entities/sale_entity.dart';
import 'package:flutter_app/features/sales/domain/usecases/get_sales_usecase.dart';
import 'package:flutter/foundation.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final GetSalesUsecase getSalesUsecase;

  SalesBloc({
    required this.getSalesUsecase,
  }) : super(SalesState()) {
    on<FetchSalesRequested>(_onFetchSalesRequested);
  }

  Future<void> _onFetchSalesRequested(
    FetchSalesRequested event,
    Emitter<SalesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    final result = await getSalesUsecase(NoParams());
    
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.msg)),
      (list) => emit(state.copyWith(isLoading: false, list: list)),
    );
  }
}
