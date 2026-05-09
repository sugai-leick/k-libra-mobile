import 'package:equatable/equatable.dart';
import 'package:flutter_app/core/typedefs/return_future.dart';
import 'package:flutter_app/core/usecase/usecase.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';
import 'package:flutter_app/features/financial/domain/repositories/financial_repository.dart';

class GetStrategicDataUseCase implements Usecase<StrategicDataParams, DreEntity> {
  final IFinancialRepository repository;

  GetStrategicDataUseCase(this.repository);

  @override
  ReturnFuture<DreEntity> call(StrategicDataParams params) async {
    return await repository.getStrategicData(
      from: params.from,
      to: params.to,
      regime: params.regime,
    );
  }
}

class StrategicDataParams extends Equatable {
  final String from;
  final String to;
  final String regime;

  const StrategicDataParams({
    required this.from,
    required this.to,
    required this.regime,
  });

  @override
  List<Object?> get props => [from, to, regime];
}
