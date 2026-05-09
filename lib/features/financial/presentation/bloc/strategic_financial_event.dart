import 'package:equatable/equatable.dart';

abstract class StrategicFinancialEvent extends Equatable {
  const StrategicFinancialEvent();

  @override
  List<Object?> get props => [];
}

class FetchStrategicDataRequested extends StrategicFinancialEvent {
  final String from;
  final String to;
  final String regime;

  const FetchStrategicDataRequested({
    required this.from,
    required this.to,
    required this.regime,
  });

  @override
  List<Object?> get props => [from, to, regime];
}
