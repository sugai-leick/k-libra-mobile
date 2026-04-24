import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_app/core/failures/failure.dart';
import 'package:flutter_app/core/usecase/params/no_params.dart';
import 'package:flutter_app/features/sales/domain/usecases/total_sales_usecase.dart';
import 'package:flutter/foundation.dart';

part 'total_sales_card_event.dart';
part 'total_sales_card_state.dart';

class TotalSalesCardBloc
    extends Bloc<TotalSalesCardEvent, TotalSalesCardState> {
  final TotalSalesUsecase totalSalesUsecase;

  TotalSalesCardBloc({required this.totalSalesUsecase})
    : super(TotalSalesCardState()) {
    on<WatchTotalSales>(_watchTotalSales);
    add(WatchTotalSales());
  }

  Future<void> _watchTotalSales(
    WatchTotalSales event,
    Emitter<TotalSalesCardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await emit.forEach<Either<Failure, int>>(
      totalSalesUsecase(NoParams()),
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
