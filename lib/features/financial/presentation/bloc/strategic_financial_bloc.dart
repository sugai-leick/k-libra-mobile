import 'package:bloc/bloc.dart';
import 'package:flutter_app/features/financial/domain/usecases/get_strategic_data_usecase.dart';

import 'strategic_financial_event.dart';
import 'strategic_financial_state.dart';

export 'strategic_financial_event.dart';
export 'strategic_financial_state.dart';

class StrategicFinancialBloc extends Bloc<StrategicFinancialEvent, StrategicFinancialState> {
  final GetStrategicDataUseCase getStrategicDataUseCase;

  StrategicFinancialBloc({required this.getStrategicDataUseCase}) : super(StrategicFinancialInitial()) {
    on<FetchStrategicDataRequested>(_onFetchStrategicDataRequested);
  }

  Future<void> _onFetchStrategicDataRequested(
    FetchStrategicDataRequested event,
    Emitter<StrategicFinancialState> emit,
  ) async {
    emit(StrategicFinancialLoading());
    final result = await getStrategicDataUseCase(StrategicDataParams(
      from: event.from,
      to: event.to,
      regime: event.regime,
    ));

    result.fold(
      (failure) => emit(StrategicFinancialError(failure.msg)),
      (dre) => emit(StrategicFinancialLoaded(dre)),
    );
  }
}
