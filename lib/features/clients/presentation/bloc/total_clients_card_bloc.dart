import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/clients/domain/usecases/total_customers_usecase.dart';
import 'package:flutter/foundation.dart';

part 'total_clients_card_event.dart';
part 'total_clients_card_state.dart';

class TotalClientsCardBloc
    extends Bloc<TotalClientsCardEvent, TotalClientsCardState> {
  final TotalCustomersUsecase totalCustomersUsecase;

  TotalClientsCardBloc({required this.totalCustomersUsecase})
    : super(TotalClientsCardState()) {
    on<WatchTotalCustomers>(_watchTotalCustomers);
    add(WatchTotalCustomers());
  }

  Future<void> _watchTotalCustomers(
    WatchTotalCustomers event,
    Emitter<TotalClientsCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await emit.forEach<Either<Failure, int>>(
      totalCustomersUsecase(NoParams()),
      onData: (either) {
        return either.fold(
          (failure) =>
              state.copyWith(error: failure.toString(), isLoading: false),
          (total) =>
              state.copyWith(totalCount: total, isLoading: false, error: null),
        );
      },
    );
  }
}
