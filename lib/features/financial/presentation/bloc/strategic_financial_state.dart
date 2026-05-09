import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/financial/domain/entities/dre_entity.dart';

abstract class StrategicFinancialState extends Equatable {
  const StrategicFinancialState();

  @override
  List<Object?> get props => [];
}

class StrategicFinancialInitial extends StrategicFinancialState {}

class StrategicFinancialLoading extends StrategicFinancialState {}

class StrategicFinancialLoaded extends StrategicFinancialState {
  final DreEntity dre;

  const StrategicFinancialLoaded(this.dre);

  @override
  List<Object?> get props => [dre];
}

class StrategicFinancialError extends StrategicFinancialState {
  final String message;

  const StrategicFinancialError(this.message);

  @override
  List<Object?> get props => [message];
}
